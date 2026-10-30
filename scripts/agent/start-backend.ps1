param([switch]$Build)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$project = Join-Path $root 'hm-dianping'
$jar = Join-Path $project 'target\hm-dianping-0.0.1-SNAPSHOT.jar'
$runDirectory = Join-Path $root '.run'
$pidFile = Join-Path $runDirectory 'backend.pid'

if (Test-Path -LiteralPath $pidFile) {
    $recorded = Get-Content -LiteralPath $pidFile -Raw
    if ($recorded -notmatch '^\s*(\d+)\s*$') { throw '无效的后台后端进程记录，请先检查 .run/backend.pid。' }
    $existing = Get-CimInstance Win32_Process -Filter "ProcessId = $($Matches[1])" -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.Name -ne 'java.exe' -or !$existing.CommandLine -or !$existing.CommandLine.Contains($jar)) {
            throw '进程记录与本练习工程不匹配，未启动或停止任何进程。'
        }
        if ($Build) { throw '后台后端仍在运行；请先用 scripts/agent/stop-backend.ps1 停止，再重新构建启动。' }
        Write-Host '本练习工程后台后端进程已存在；请另行检查 /practice/status 和业务接口。'
        exit 0
    }
    Remove-Item -LiteralPath $pidFile
}

$client = [System.Net.Sockets.TcpClient]::new()
try {
    $occupied = $false
    try { $occupied = $client.ConnectAsync('127.0.0.1', 18081).Wait(1000) -and $client.Connected } catch { }
    if ($occupied) { throw '18081 已被占用，请先确认是否由 IDEA 或终端启动；未停止任何进程。' }
} finally { $client.Dispose() }

Push-Location $project
try {
    if ($Build -or !(Test-Path -LiteralPath $jar)) {
        & mvn '-DskipTests' package
        if ($LASTEXITCODE -ne 0) { throw '构建失败，未启动后台后端。' }
    }
} finally { Pop-Location }

New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null
$javaCommand = (Get-Command java -ErrorAction Stop).Source
$process = Start-Process -FilePath $javaCommand -ArgumentList @('-jar', ('"' + $jar + '"')) -WorkingDirectory $project -WindowStyle Hidden -RedirectStandardOutput (Join-Path $runDirectory 'backend.out.log') -RedirectStandardError (Join-Path $runDirectory 'backend.err.log') -PassThru
Set-Content -LiteralPath $pidFile -Value $process.Id -Encoding ascii

for ($attempt = 0; $attempt -lt 30; $attempt++) {
    $process.Refresh()
    if ($process.HasExited) {
        Remove-Item -LiteralPath $pidFile
        throw '后台后端已退出，请检查 .run/backend.out.log 和 .run/backend.err.log；分享日志前隐藏敏感信息。'
    }
    try {
        $status = Invoke-RestMethod -Uri 'http://127.0.0.1:18081/practice/status' -TimeoutSec 1
        if ($status.success -and $status.data.project -eq 'dianping-practice') {
            Write-Host '后台后端已响应：http://127.0.0.1:18081；日志在 .run/backend.out.log 和 .run/backend.err.log。'
            Write-Host '本次仅确认应用响应，MySQL、Redis 和业务仍需分别验证。'
            exit 0
        }
    } catch { }
    Start-Sleep -Milliseconds 500
}
throw '后台后端尚未确认就绪，已保留 PID 记录；请检查日志，必要时使用配套停止脚本。'
