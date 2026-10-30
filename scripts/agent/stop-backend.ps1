$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$pidFile = Join-Path $root '.run/backend.pid'
if (!(Test-Path -LiteralPath $pidFile)) {
    Write-Host '没有助手后台启动记录。若在 IDEA 或终端运行，请从对应位置停止。'
    exit 0
}
$recorded = Get-Content -LiteralPath $pidFile -Raw
if ($recorded -notmatch '^\s*(\d+)\s*$') { throw '无效的后台后端进程记录，未停止任何进程。' }
$savedPid = [int]$Matches[1]
$process = Get-CimInstance Win32_Process -Filter "ProcessId = $savedPid" -ErrorAction SilentlyContinue
if (!$process) {
    Remove-Item -LiteralPath $pidFile
    Write-Host '记录中的后端已停止，已清理过期记录。'
    exit 0
}
$expectedJar = Join-Path $root 'hm-dianping\target\hm-dianping-0.0.1-SNAPSHOT.jar'
if ($process.Name -ne 'java.exe' -or !$process.CommandLine -or !$process.CommandLine.Contains($expectedJar)) {
    throw '进程与本练习工程不匹配，未停止任何进程。'
}
Stop-Process -Id $savedPid
Remove-Item -LiteralPath $pidFile
Write-Host '练习版后台后端已停止。'
