[CmdletBinding(SupportsShouldProcess=$true)]
param([string]$PackagePath, [string]$GamePath='C:\Program Files (x86)\Steam\steamapps\common\ClearedHot')
. (Join-Path $PSScriptRoot 'common.ps1')
if (-not $PackagePath) { $PackagePath = Get-WorkspacePath ('release/ClearedHotTrainer-' + (Get-ProjectVersion)) }
$uninstaller = Join-Path $PackagePath 'Uninstall.ps1'
if (-not (Test-Path -LiteralPath $uninstaller -PathType Leaf)) { throw 'Original installation package and its install-state.json are required.' }
& $uninstaller -GamePath $GamePath -WhatIf:$WhatIfPreference
