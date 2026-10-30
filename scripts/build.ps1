[CmdletBinding()]
param(
    [switch]$PublicOnly,
    [switch]$NoRestore,
    [string]$GameReferencePath,
    [string]$BepInExCorePath,
    [string]$InteropReferencePath,
    [string]$DotNetPath
)
. (Join-Path $PSScriptRoot 'common.ps1')
Initialize-DotNet $DotNetPath
$tests = Get-WorkspacePath 'tests/ClearedHotTrainer.Tests/ClearedHotTrainer.Tests.csproj'
if (-not $PublicOnly) {
    $refs = Resolve-LocalReferences $GameReferencePath $BepInExCorePath $InteropReferencePath
    $project = Get-WorkspacePath 'src/ClearedHotTrainer/ClearedHotTrainer.csproj'
    $properties = @("-p:GameReferencePath=$($refs.Game)", "-p:BepInExReferencePath=$($refs.Core)", "-p:InteropReferencePath=$($refs.Interop)")
    if (-not $NoRestore) { Invoke-ProjectDotNet (@('restore', $project) + $properties) 'restore-plugin.log' }
    Invoke-ProjectDotNet (@('build', $project, '-c', 'Release', '--no-restore') + $properties) 'build-plugin.log'
}
if (-not $NoRestore) { Invoke-ProjectDotNet @('restore', $tests) 'restore-tests.log' }
Invoke-ProjectDotNet @('build', $tests, '-c', 'Release', '--no-restore') 'build-public.log'
if ($PublicOnly) {
    Write-Output 'PUBLIC BUILD ONLY: test executable and actual production ProtectionPolicy.cs compiled. Plugin NOT compiled.'
} else {
    Write-Output 'Full plugin and public tests compiled in Release. Gameplay validation is still pending.'
}
