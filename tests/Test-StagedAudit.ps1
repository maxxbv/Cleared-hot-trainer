[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$fixture=Join-Path $root ('work/staged-audit-fixture-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force (Join-Path $fixture 'scripts') | Out-Null
Copy-Item -LiteralPath (Join-Path $root 'scripts/audit.ps1'),(Join-Path $root 'scripts/common.ps1') -Destination (Join-Path $fixture 'scripts')
& git -C $fixture init --initial-branch=main --quiet
if ($LASTEXITCODE -ne 0) { throw 'Fixture git init failed' }
$probe=Join-Path $fixture 'example.txt'
('value = "' + ('gh' + 'p_' + ('x' * 36)) + '"') | Set-Content -LiteralPath $probe
& git -C $fixture add -- example.txt
if ($LASTEXITCODE -ne 0) { throw 'Fixture git add failed' }
'clean working-tree content' | Set-Content -LiteralPath $probe
$rejected=$false
try { & (Join-Path $fixture 'scripts/audit.ps1') -NoReport | Out-Null } catch {
    if ($_.Exception.Message -notmatch 'Audit failed') { throw }
    $rejected=$true
}
if (-not $rejected) { throw 'FAIL: staged credential was accepted after working-tree cleanup' }
& git -C $fixture add -- example.txt
& (Join-Path $fixture 'scripts/audit.ps1') -NoReport | Out-Null
Write-Output 'PASS: staged credential rejected despite clean working tree; clean index accepted after restaging.'
