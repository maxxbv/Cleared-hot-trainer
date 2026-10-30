[CmdletBinding(SupportsShouldProcess=$true)]
param([string]$GamePath = 'C:\Program Files (x86)\Steam\steamapps\common\ClearedHot')
. (Join-Path $PSScriptRoot 'Package.Common.ps1')
$root = Get-Root $GamePath
$package = Get-Root $PSScriptRoot
Assert-PackageOutsideGame $package $root
if (Get-Process -Name ClearedHot -ErrorAction SilentlyContinue) { throw 'Close Cleared Hot first.' }
$statePath = Get-ChildPath $package 'install-state.json'
$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
if ($state.GameRoot -ne $root -or $state.RelativePath -ne $script:PluginRelative) { throw 'Installation record does not match this directory.' }
$target = Get-ChildPath $root $script:PluginRelative
if (-not (Test-Path -LiteralPath $target)) { Write-Output 'Plugin DLL is already absent; backup and record retained.'; return }
if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $state.SHA256) { throw 'Plugin file changed since installation. Refusing to delete an unrecognized file.' }
if (-not $PSCmdlet.ShouldProcess($target, 'Remove ONLY the recorded plugin DLL; preserve game files, backups, BepInEx, and configuration')) { return }
Remove-Item -LiteralPath $target
$directory = Split-Path -Parent $target
if (@(Get-ChildItem -LiteralPath $directory -Force).Count -eq 0) { Remove-Item -LiteralPath $directory }
$state.Status = 'Removed'
$state | ConvertTo-Json | Set-Content -LiteralPath $statePath -Encoding UTF8
Write-Output 'Plugin removed. Configuration, BepInEx and backup retained. No original needs restoration because none was modified.'
