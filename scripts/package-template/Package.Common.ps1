Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:PluginRelative = 'BepInEx\plugins\ClearedHot.LocalAssist\ClearedHot.LocalAssist.dll'
$script:ExpectedGameHashes = @{
    'GameAssembly.dll' = '799A0071688939779D17BA2B9C68E9F665FC0124F7080B27657586620FE5C72A'
    'ClearedHot_Data\il2cpp_data\Metadata\global-metadata.dat' = '4D4B444705E4889848971415DAD423000793E3823AC8C974774302B259542A93'
}
function Get-Root([string]$Path) {
    $item = Get-Item -LiteralPath $Path
    if (-not $item.PSIsContainer) { throw "Not a directory: $Path" }
    return [IO.Path]::GetFullPath($item.FullName).TrimEnd('\')
}
function Get-ChildPath([string]$Root, [string]$Relative) {
    $full = [IO.Path]::GetFullPath((Join-Path $Root $Relative))
    if (-not $full.StartsWith($Root.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path leaves intended directory: $full"
    }
    $cursor = $full
    while ($cursor.Length -ge $Root.Length) {
        if (Test-Path -LiteralPath $cursor) {
            $item = Get-Item -LiteralPath $cursor -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { throw "Reparse point rejected: $cursor" }
        }
        if ($cursor -eq $Root) { break }
        $cursor = Split-Path -Parent $cursor
    }
    return $full
}
function Assert-Game([string]$Root) {
    if (-not (Test-Path -LiteralPath (Get-ChildPath $Root 'ClearedHot.exe'))) { throw 'ClearedHot.exe missing.' }
    foreach ($relative in $script:ExpectedGameHashes.Keys) {
        $actual = (Get-FileHash -LiteralPath (Get-ChildPath $Root $relative) -Algorithm SHA256).Hash
        if ($actual -ne $script:ExpectedGameHashes[$relative]) { throw "Unsupported game build: $relative" }
    }
    if (Get-Process -Name ClearedHot -ErrorAction SilentlyContinue) { throw 'Close Cleared Hot first.' }
}
function Assert-PackageOutsideGame([string]$PackageRoot, [string]$GameRoot) {
    if ($PackageRoot -eq $GameRoot -or $PackageRoot.StartsWith($GameRoot + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Extract this package outside the game directory before running it.'
    }
}
function Assert-Loader([string]$Root) {
    $core = Get-ChildPath $Root 'BepInEx\core\BepInEx.Core.dll'
    if (-not (Test-Path -LiteralPath $core)) { throw 'BepInEx 6 IL2CPP loader missing. This installer installs only the plugin.' }
    $version = [Diagnostics.FileVersionInfo]::GetVersionInfo($core).ProductVersion
    if ($version -notmatch '^6\.0\.0-be\.(\d+)' -or [int]$Matches[1] -lt 791) {
        throw "Use an official BepInEx 6 IL2CPP win-x64 build >=791; detected '$version'. pre.2 is not supported."
    }
    $runtime = Get-ChildPath $Root 'BepInEx\core\Il2CppInterop.Runtime.dll'
    $interopVersion = [Diagnostics.FileVersionInfo]::GetVersionInfo($runtime).FileVersion
    if ([version]$interopVersion -lt [version]'1.5.3.0') { throw "Il2CppInterop >=1.5.3 required; detected $interopVersion" }
    foreach ($name in @('BepInEx.Unity.IL2CPP.dll','Il2CppInterop.HarmonySupport.dll','0Harmony.dll')) {
        if (-not (Test-Path -LiteralPath (Get-ChildPath $Root ("BepInEx\core\" + $name)))) { throw "Missing loader dependency: $name" }
    }
    Write-Output "Loader files present: BepInEx $version / Interop $interopVersion. Runtime compatibility still requires a game test."
}
