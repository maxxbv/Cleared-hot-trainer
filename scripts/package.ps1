[CmdletBinding()]
param([switch]$SkipBuild, [string]$GameReferencePath, [string]$BepInExCorePath, [string]$InteropReferencePath, [string]$DotNetPath)
. (Join-Path $PSScriptRoot 'common.ps1')
$version = Get-ProjectVersion
$package = Get-WorkspacePath ("release/ClearedHotTrainer-$version")
$zip = $package + '.zip'
if ((Test-Path -LiteralPath $package) -or (Test-Path -LiteralPath $zip)) { throw 'Package already exists; archive it explicitly rather than overwriting it.' }
$templateNames = @('Install.ps1','Uninstall.ps1','Package.Common.ps1')
foreach ($name in $templateNames) {
    if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot ('package-template/' + $name)) -PathType Leaf)) { throw "Package template missing: $name" }
}
foreach ($name in @('docs/INSTALLATION.md','docs/TESTING.md','PROJECT_STATUS.md','ARCHITECTURE.md','CHANGELOG.md')) {
    if (-not (Test-Path -LiteralPath (Get-WorkspacePath $name) -PathType Leaf)) { throw "Package document missing: $name" }
}
$refs = Resolve-LocalReferences $GameReferencePath $BepInExCorePath $InteropReferencePath
if (-not $SkipBuild) {
    & (Join-Path $PSScriptRoot 'build.ps1') -GameReferencePath $refs.Game -BepInExCorePath $refs.Core -InteropReferencePath $refs.Interop -DotNetPath $DotNetPath
}
$dll = Get-WorkspacePath 'build/bin/ClearedHotTrainer/Release/net6.0/ClearedHot.LocalAssist.dll'
if (-not (Test-Path -LiteralPath $dll)) { throw 'Full plugin DLL missing. A public-only build cannot be packaged as the plugin.' }
$productVersion = [Diagnostics.FileVersionInfo]::GetVersionInfo($dll).ProductVersion
if ($productVersion -ne $version -and -not $productVersion.StartsWith($version + '+', [StringComparison]::Ordinal)) {
    throw "DLL version '$productVersion' does not match project '$version'. Rebuild before packaging."
}
& (Join-Path $PSScriptRoot 'test.ps1') -WithContracts -GameReferencePath $refs.Game -PluginPath $dll -DotNetPath $DotNetPath
$relative = 'BepInEx\plugins\ClearedHot.LocalAssist\ClearedHot.LocalAssist.dll'
$payload = Join-Path $package ('payload\' + $relative)
New-Item -ItemType Directory -Force (Split-Path -Parent $payload) | Out-Null
Copy-Item -LiteralPath $dll -Destination $payload
foreach ($name in $templateNames) {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot ('package-template/' + $name)) -Destination $package
}
foreach ($name in @('PROJECT_STATUS.md','ARCHITECTURE.md','CHANGELOG.md')) {
    Copy-Item -LiteralPath (Get-WorkspacePath $name) -Destination $package
}
Copy-Item -LiteralPath (Get-WorkspacePath 'docs/INSTALLATION.md') -Destination (Join-Path $package 'README.md')
New-Item -ItemType Directory -Path (Join-Path $package 'docs') | Out-Null
Copy-Item -LiteralPath (Get-WorkspacePath 'docs/TESTING.md') -Destination (Join-Path $package 'docs/TESTING.md')
@{
    Name='Cleared Hot Trainer'; Version=$version; Status='Experimental; runtime unvalidated'
    RelativePath=$relative; SHA256=(Get-FileHash -LiteralPath $payload -Algorithm SHA256).Hash
    LoaderIncluded=$false; GameReferencesIncluded=$false
} | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $package 'manifest.json') -Encoding utf8
$expected = @(('payload/' + $relative.Replace('\','/')), 'Install.ps1','Uninstall.ps1','Package.Common.ps1','README.md','PROJECT_STATUS.md','ARCHITECTURE.md','CHANGELOG.md','docs/TESTING.md','manifest.json')
$actualFiles = @(Get-ChildItem -LiteralPath $package -File -Recurse)
if ($actualFiles.Count -ne $expected.Count) { throw 'Package file count differs from allowlist.' }
foreach ($file in $actualFiles) {
    $name = $file.FullName.Substring($package.Length+1).Replace('\','/')
    if ($name -notin $expected) { throw "Unexpected package file: $name" }
}
Compress-Archive -LiteralPath $package -DestinationPath $zip
Write-Output "Local alpha package: $zip. No tag, release, remote upload or installation performed."
