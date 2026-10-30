[CmdletBinding()]
param([string[]]$Paths, [switch]$NoReport)
. (Join-Path $PSScriptRoot 'common.ps1')
function Read-GitBytes([string[]]$Arguments) {
    $start = [Diagnostics.ProcessStartInfo]::new()
    $start.FileName = (Get-Command git -ErrorAction Stop).Source
    $start.WorkingDirectory = $script:RepositoryRoot
    $start.UseShellExecute = $false
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    foreach ($argument in $Arguments) { $start.ArgumentList.Add($argument) }
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $start
    $memory = [IO.MemoryStream]::new()
    try {
        if (-not $process.Start()) { throw 'Could not start Git.' }
        $process.StandardOutput.BaseStream.CopyTo($memory)
        $errorText = $process.StandardError.ReadToEnd()
        $process.WaitForExit()
        if ($process.ExitCode -ne 0) { throw "Git inspection failed: $errorText" }
        return ,$memory.ToArray()
    } finally { $memory.Dispose(); $process.Dispose() }
}
Push-Location $script:RepositoryRoot
try {
    $explicitPaths = $PSBoundParameters.ContainsKey('Paths')
    $entries = [Collections.Generic.List[object]]::new()
    if ($explicitPaths) {
        if (-not $Paths.Count) { throw 'Explicit Paths must not be empty.' }
        foreach ($path in $Paths) { $entries.Add(@{Name=$path;Hash='';Mode='working-tree';Stage='0'}) }
    } else {
        $index = [Text.Encoding]::UTF8.GetString((Read-GitBytes @('ls-files','--stage','-z')))
        foreach ($record in $index.Split([char]0)) {
            if (-not $record) { continue }
            if ($record -notmatch '^([0-7]{6}) ([0-9a-f]{40}|[0-9a-f]{64}) ([0-3])\t(.*)$') { throw 'Cannot parse Git index safely.' }
            $entries.Add(@{Name=$Matches[4];Hash=$Matches[2];Mode=$Matches[1];Stage=$Matches[3]})
        }
    }
    $findings = [Collections.Generic.List[object]]::new()
    $rules = @{
        GitHubToken = 'gh[pousr]_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{30,}'
        AwsAccessKey = 'AKIA[0-9A-Z]{16}'
        PrivateKey = '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
        AssignedCredential = '(?i)(?:api[_-]?key|password|client[_-]?secret|access[_-]?token)\s*[:=]\s*["''](?!<|YOUR_|EXAMPLE|CHANGEME)[A-Za-z0-9+/=_-]{12,}["'']'
        PersonalProfile = '[A-Za-z]:\\Users\\[^\\\s]+'
    }
    $forbiddenExtension = '\.(dll|exe|pdb|dat|zip|7z|rar|nupkg|unity|assets?|prefab|bundle|sav|save|pem|key|pfx|p12|log)$'
    $forbiddenDirectory = '^(work|outputs|build|release|logs|backups)/|(^|/)(bin|obj|ClearedHot_Data|Saves|SaveGames)/|(^|/)BepInEx/(core|interop)/'
    $utf8 = [Text.UTF8Encoding]::new($false,$true)
    foreach ($entry in $entries) {
        $normal = $entry.Name.Replace('\','/')
        $path = Get-WorkspacePath $entry.Name
        if ($normal -match $forbiddenDirectory -or $normal -match $forbiddenExtension -or
            $normal -match '(^|/)(\.env($|\.)|\.git-credentials$|credentials|secrets)') {
            $findings.Add(@{Path=$normal;Rule='ForbiddenContent';Line=0}); continue
        }
        if (-not $explicitPaths) {
            if ($entry.Stage -ne '0' -or $entry.Mode -notin @('100644','100755')) {
                $findings.Add(@{Path=$normal;Rule='UnsupportedIndexModeOrConflict';Line=0}); continue
            }
            $size = [long]([Text.Encoding]::ASCII.GetString((Read-GitBytes @('cat-file','-s',$entry.Hash))).Trim())
            if ($size -gt 1MB) { $findings.Add(@{Path=$normal;Rule='FileOver1MB';Line=0}); continue }
            $bytes = Read-GitBytes @('cat-file','blob',$entry.Hash)
        } else {
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { $findings.Add(@{Path=$normal;Rule='MissingFile';Line=0}); continue }
            if ((Get-Item -LiteralPath $path).Length -gt 1MB) { $findings.Add(@{Path=$normal;Rule='FileOver1MB';Line=0}); continue }
            $bytes = [IO.File]::ReadAllBytes($path)
        }
        if ($bytes -contains 0 -or ($bytes.Length -ge 2 -and $bytes[0] -eq 77 -and $bytes[1] -eq 90)) {
            $findings.Add(@{Path=$normal;Rule='BinaryContent';Line=0}); continue
        }
        try { $content = $utf8.GetString($bytes) } catch {
            $findings.Add(@{Path=$normal;Rule='NonUtf8Content';Line=0}); continue
        }
        $lines = [regex]::Split($content,'\r?\n')
        for ($i=0; $i -lt $lines.Length; $i++) {
            foreach ($rule in $rules.Keys) {
                if ($lines[$i] -match $rules[$rule]) { $findings.Add(@{Path=$normal;Rule=$rule;Line=$i+1}) }
            }
        }
    }
    $historyCount = [int]([Text.Encoding]::ASCII.GetString((Read-GitBytes @('rev-list','--all','--count'))).Trim())
    $scope = if ($explicitPaths) { 'Explicit working-tree paths' } else { 'Exact stage-0 blobs from Git index' }
    $report = @{
        CandidateFiles=$entries.Count; FindingCount=$findings.Count; Findings=@($findings.ToArray())
        CommitsPresent=$historyCount; Scope=$scope
        HistoricalBlobScanPerformed=$false; CompleteSecretDetector=$false
    }
    if (-not $NoReport) {
        New-Item -ItemType Directory -Force (Get-WorkspacePath 'logs') | Out-Null
        $report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Get-WorkspacePath 'logs/git-audit.json') -Encoding utf8
    }
    if ($findings.Count) {
        $findings.ToArray() | ForEach-Object { Write-Output ("{0}:{1}: {2}" -f $_.Path,$_.Line,$_.Rule) }
        throw "Audit failed: $($findings.Count) findings. Values were not printed."
    }
    Write-Output "Audit passed: $($entries.Count) files, scope=$scope; $historyCount existing commits. No prohibited content or high-confidence credential/profile pattern found in this scope."
} finally { Pop-Location }
