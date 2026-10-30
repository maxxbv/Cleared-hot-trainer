[CmdletBinding(SupportsShouldProcess=$true)]
param([string]$PackagePath, [string]$GamePath='C:\Program Files (x86)\Steam\steamapps\common\ClearedHot')
. (Join-Path $PSScriptRoot 'common.ps1')
if (-not $PackagePath) { $PackagePath = Get-WorkspacePath ('release/ClearedHotTrainer-' + (Get-ProjectVersion)) }
$installer = Join-Path $PackagePath 'Install.ps1'
if (-not (Test-Path -LiteralPath $installer -PathType Leaf)) { throw 'Generated package missing. Run scripts/package.ps1 first.' }
& $installer -GamePath $GamePath -WhatIf:$WhatIfPreference
