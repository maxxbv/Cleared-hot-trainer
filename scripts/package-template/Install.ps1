[CmdletBinding(SupportsShouldProcess=$true)]
param([string]$GamePath = 'C:\Program Files (x86)\Steam\steamapps\common\ClearedHot')
. (Join-Path $PSScriptRoot 'Package.Common.ps1')
$root = Get-Root $GamePath
$package = Get-Root $PSScriptRoot
Assert-PackageOutsideGame $package $root
Assert-Game $root
Assert-Loader $root
$manifest = Get-Content -LiteralPath (Join-Path $package 'manifest.json') -Raw | ConvertFrom-Json
if ($manifest.RelativePath -ne $script:PluginRelative) { throw 'Unexpected manifest path.' }
$source = Get-ChildPath $package ('payload\' + $script:PluginRelative)
if ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -ne $manifest.SHA256) { throw 'Plugin package checksum mismatch.' }
$target = Get-ChildPath $root $script:PluginRelative
if (Test-Path -LiteralPath $target) { throw 'Plugin already exists; nothing overwritten. Remove or back it up separately first.' }
$statePath = Get-ChildPath $package 'install-state.json'
if (Test-Path -LiteralPath $statePath) { throw 'An installation record already exists in this package; inspect it before proceeding.' }
if (-not $PSCmdlet.ShouldProcess($root, 'Back up original DLL and metadata outside the game, then ADD ONLY ClearedHot.LocalAssist.dll')) { return }
$backup = Get-ChildPath $package ('backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
foreach ($relative in $script:ExpectedGameHashes.Keys) {
    $copy = Get-ChildPath $backup $relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $copy) -Force | Out-Null
    Copy-Item -LiteralPath (Get-ChildPath $root $relative) -Destination $copy
    if ((Get-FileHash -LiteralPath $copy -Algorithm SHA256).Hash -ne $script:ExpectedGameHashes[$relative]) { throw 'Backup verification failed; plugin not installed.' }
}
@{ GameRoot=$root; RelativePath=$script:PluginRelative; SHA256=$manifest.SHA256; Backup=$backup; Status='Prepared' } |
    ConvertTo-Json | Set-Content -LiteralPath $statePath -Encoding UTF8
New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $target
if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $manifest.SHA256) { throw 'Installed file verification failed; inspect install-state.json and remove only the plugin file.' }
@{ GameRoot=$root; RelativePath=$script:PluginRelative; SHA256=$manifest.SHA256; Backup=$backup; Status='Installed' } |
    ConvertTo-Json | Set-Content -LiteralPath $statePath -Encoding UTF8
Write-Output "Plugin added. Backups: $backup. No original game file was overwritten. Start via Steam and validate LogOutput.txt and a mission."
