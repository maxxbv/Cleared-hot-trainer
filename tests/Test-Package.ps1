[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$PackagePath,
    [Parameter(Mandatory=$true)][string]$OriginalGamePath,
    [Parameter(Mandatory=$true)][string]$FixtureCoreDll,
    [Parameter(Mandatory=$true)][string]$RuntimeDll,
    [Parameter(Mandatory=$true)][string]$HarmonySupportDll,
    [Parameter(Mandatory=$true)][string]$LoaderDll,
    [Parameter(Mandatory=$true)][string]$HarmonyDll,
    [Parameter(Mandatory=$true)][string]$TestRoot
)
$ErrorActionPreference = 'Stop'
if (Test-Path -LiteralPath $TestRoot) { throw 'Use a NEW empty test path.' }
$fixture = [IO.Path]::GetFullPath($TestRoot)
$game = Join-Path $fixture 'game'
$package = Join-Path $fixture 'package'
$relative = 'BepInEx\plugins\ClearedHot.LocalAssist\ClearedHot.LocalAssist.dll'
$core = Join-Path $game 'BepInEx\core'
$metadata = 'ClearedHot_Data\il2cpp_data\Metadata\global-metadata.dat'
New-Item -ItemType Directory -Force -Path $core,(Join-Path $game (Split-Path -Parent $metadata)),(Join-Path $package ('payload\' + (Split-Path -Parent $relative))) | Out-Null
foreach ($name in @('Install.ps1','Uninstall.ps1','Package.Common.ps1','manifest.json')) {
    Copy-Item -LiteralPath (Join-Path $PackagePath $name) -Destination $package
}
$payload = Join-Path $package ('payload\' + $relative)
Copy-Item -LiteralPath (Join-Path $PackagePath ('payload\' + $relative)) -Destination $payload
Copy-Item -LiteralPath (Join-Path $OriginalGamePath 'GameAssembly.dll'),(Join-Path $OriginalGamePath 'ClearedHot.exe') -Destination $game
Copy-Item -LiteralPath (Join-Path $OriginalGamePath $metadata) -Destination (Join-Path $game $metadata)
Copy-Item -LiteralPath $FixtureCoreDll -Destination (Join-Path $core 'BepInEx.Core.dll')
Copy-Item -LiteralPath $RuntimeDll,$HarmonySupportDll,$LoaderDll,$HarmonyDll -Destination $core
$target = Join-Path $game $relative
$statePath = Join-Path $package 'install-state.json'
$script:checks = 0
function Check([bool]$Pass,[string]$Name) { if (-not $Pass) { throw "FAIL: $Name" }; $script:checks++; Write-Output "PASS: $Name" }
function Reject([scriptblock]$Action,[string]$Name) {
    $rejected = $false
    try { & $Action | Out-Null } catch { $rejected = $true }
    Check $rejected $Name
}
& (Join-Path $package 'Install.ps1') -GamePath $game -WhatIf
Check (-not (Test-Path -LiteralPath $statePath)) 'install WhatIf has no state mutation'
& (Join-Path $package 'Install.ps1') -GamePath $game
Check (Test-Path -LiteralPath $target) 'install copies plugin'
$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
foreach ($r in @('GameAssembly.dll',$metadata)) {
    $originalHash = (Get-FileHash -LiteralPath (Join-Path $OriginalGamePath $r)).Hash
    Check ((Get-FileHash -LiteralPath (Join-Path $state.Backup $r)).Hash -eq $originalHash) "backup verified: $r"
}
Reject { & (Join-Path $package 'Install.ps1') -GamePath $game } 'existing plugin is never overwritten'
[IO.File]::AppendAllText($target, 'changed')
Reject { & (Join-Path $package 'Uninstall.ps1') -GamePath $game } 'changed DLL is not deleted'
Check (Test-Path -LiteralPath $target) 'changed DLL remains present'
Copy-Item -LiteralPath $payload -Destination $target -Force
$marker = Join-Path $game 'BepInEx\plugins\unrelated.txt'
'unrelated' | Set-Content -LiteralPath $marker
& (Join-Path $package 'Uninstall.ps1') -GamePath $game -WhatIf
Check (Test-Path -LiteralPath $target) 'uninstall WhatIf preserves plugin'
& (Join-Path $package 'Uninstall.ps1') -GamePath $game
Check (-not (Test-Path -LiteralPath $target)) 'uninstall removes only plugin'
Check (Test-Path -LiteralPath $marker) 'unrelated mod file preserved'
foreach ($r in @('GameAssembly.dll',$metadata)) {
    Check ((Get-FileHash -LiteralPath (Join-Path $game $r)).Hash -eq (Get-FileHash -LiteralPath (Join-Path $OriginalGamePath $r)).Hash) "original unchanged: $r"
}
Reject { & (Join-Path $package 'Uninstall.ps1') -GamePath $fixture } 'wrong destination refused'
. (Join-Path $package 'Package.Common.ps1')
Reject { Get-ChildPath $game '..\outside.dll' } 'path escape refused'
Write-Output "$script:checks package checks passed. FILE OPERATIONS ONLY; fixture loader was never executed. Artifacts retained in $fixture"
