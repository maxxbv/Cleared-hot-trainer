[CmdletBinding()]
param(
    [switch]$WithContracts,
    [switch]$NoBuild,
    [string]$GameReferencePath,
    [string]$PluginPath,
    [string]$DotNetPath
)
. (Join-Path $PSScriptRoot 'common.ps1')
Initialize-DotNet $DotNetPath
$arguments = @('run', '--project', (Get-WorkspacePath 'tests/ClearedHotTrainer.Tests/ClearedHotTrainer.Tests.csproj'), '-c', 'Release')
if ($NoBuild) { $arguments += @('--no-build', '--no-restore') }
if ($WithContracts) {
    if (-not $GameReferencePath) { $GameReferencePath = Get-WorkspacePath 'work/interop-791/generated' }
    if (-not $PluginPath) { $PluginPath = Get-WorkspacePath 'build/bin/ClearedHotTrainer/Release/net6.0/ClearedHot.LocalAssist.dll' }
    $wrapper = Join-Path $GameReferencePath 'Cfinger.Runtime.dll'
    foreach ($path in @($wrapper, $PluginPath)) {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Contract-test input missing: $path" }
    }
    $arguments += @('--', [IO.Path]::GetFullPath($wrapper), [IO.Path]::GetFullPath($PluginPath))
} else { Write-Output 'PUBLIC TESTS: game contracts and Unity/IL2CPP runtime are NOT being tested.' }
Invoke-ProjectDotNet $arguments 'tests.log'
