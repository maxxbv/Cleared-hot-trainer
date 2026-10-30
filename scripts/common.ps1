Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:RepositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd('\')
function Get-ProjectVersion {
    [xml]$props = Get-Content -LiteralPath (Join-Path $script:RepositoryRoot 'Directory.Build.props') -Raw
    return [string]$props.Project.PropertyGroup.Version
}
function Get-WorkspacePath([string]$Relative) {
    $path = [IO.Path]::GetFullPath((Join-Path $script:RepositoryRoot $Relative))
    if (-not $path.StartsWith($script:RepositoryRoot + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path leaves repository workspace: $Relative"
    }
    return $path
}
function Initialize-DotNet([string]$DotNetPath = '') {
    if ($DotNetPath) {
        $script:DotNet = (Resolve-Path -LiteralPath $DotNetPath).Path
    } elseif (Test-Path -LiteralPath (Get-WorkspacePath 'work/tools/dotnet/dotnet.exe')) {
        $script:DotNet = Get-WorkspacePath 'work/tools/dotnet/dotnet.exe'
    } else {
        $script:DotNet = (Get-Command dotnet -ErrorAction Stop).Source
    }
    $env:DOTNET_CLI_HOME = Get-WorkspacePath 'work/dotnet-home'
    $env:DOTNET_ADD_GLOBAL_TOOLS_TO_PATH = '0'
    $env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
    $env:DOTNET_GENERATE_ASPNET_CERTIFICATE = 'false'
    $env:DOTNET_NOLOGO = '1'
    $env:NUGET_PACKAGES = Get-WorkspacePath 'work/nuget'
    New-Item -ItemType Directory -Force (Get-WorkspacePath 'logs') | Out-Null
}
function Invoke-ProjectDotNet([string[]]$Arguments, [string]$LogName) {
    Push-Location $script:RepositoryRoot
    try {
        & $script:DotNet @Arguments 2>&1 | Tee-Object -FilePath (Get-WorkspacePath ('logs/' + $LogName))
        if ($LASTEXITCODE -ne 0) { throw "dotnet failed ($LASTEXITCODE). See logs/$LogName" }
    } finally { Pop-Location }
}
function Resolve-LocalReferences([string]$GameReferencePath, [string]$BepInExCorePath, [string]$InteropReferencePath) {
    if (-not $GameReferencePath) { $GameReferencePath = Get-WorkspacePath 'work/interop' }
    if (-not $BepInExCorePath) { $BepInExCorePath = Get-WorkspacePath 'work/tools/bepinex-pre2/BepInEx/core' }
    if (-not $InteropReferencePath) { $InteropReferencePath = Get-WorkspacePath 'work/tools/interop-Runtime/net6.0' }
    foreach ($p in @($GameReferencePath, $BepInExCorePath, $InteropReferencePath)) {
        if (-not (Test-Path -LiteralPath $p -PathType Container)) {
            throw "Reference directory missing: $p. Full plugin builds require local game interop and public loader API references; see DEVELOPMENT.md."
        }
    }
    return @{
        Game = (Resolve-Path -LiteralPath $GameReferencePath).Path
        Core = (Resolve-Path -LiteralPath $BepInExCorePath).Path
        Interop = (Resolve-Path -LiteralPath $InteropReferencePath).Path
    }
}
