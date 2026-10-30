[CmdletBinding()]
param()
$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$fixture=Join-Path $root ('work/audit-fixture-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force $fixture | Out-Null
function Expect-Refusal([string]$Path) {
    $refused=$false
    try { & (Join-Path $root 'scripts/audit.ps1') -Paths @($Path) -NoReport | Out-Null } catch { $refused=$true }
    if (-not $refused) { throw "Audit accepted prohibited input: $Path" }
}
# Forbidden directory and extension must both be rejected before content is considered.
'fixture' | Set-Content -LiteralPath (Join-Path $fixture 'GameAssembly.dll')
Expect-Refusal ((Join-Path $fixture 'GameAssembly.dll').Substring($root.Length+1))
# A direct safe-looking source path with a credential tests the content rule independently.
$probe=Join-Path $root ('analysis/audit-fixture-' + [guid]::NewGuid().ToString('N') + '.txt')
try {
    ('value = "' + ('gh' + 'p_' + ('x' * 36)) + '"') | Set-Content -LiteralPath $probe
    Expect-Refusal ($probe.Substring($root.Length+1))
} finally {
    # Remove only this exact generated test file, never a directory tree.
    if (Test-Path -LiteralPath $probe) { Remove-Item -LiteralPath $probe }
}
Write-Output 'PASS: audit rejects proprietary-path fixtures and credential content.'
