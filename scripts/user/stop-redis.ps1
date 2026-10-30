$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$config = Join-Path $root '.local/redis.conf'
$pidFile = Join-Path $root '.run/redis.pid'
if (!(Test-Path -LiteralPath $pidFile)) { Write-Host '没有本练习版 Redis 的启动记录。'; exit 0 }
$recorded = Get-Content -LiteralPath $pidFile -Raw
if ($recorded -notmatch '^\s*(\d+)\s*$') { throw '无效的练习实例记录。' }
$process = Get-CimInstance Win32_Process -Filter "ProcessId = $($Matches[1])" -ErrorAction SilentlyContinue
if (!$process) { Write-Host '练习版 Redis 已停止。'; exit 0 }
if (!$process.CommandLine -or !$process.CommandLine.Contains($config)) { throw '实例与练习工程不匹配，未停止任何进程。' }
$authLine = Get-Content -LiteralPath $config | Where-Object { $_ -match '^requirepass ' } | Select-Object -First 1
$previousAuth = $env:REDISCLI_AUTH
try {
    if ($authLine) { $env:REDISCLI_AUTH = ($authLine.Substring(12) | ConvertFrom-Json) }
    else { Remove-Item Env:\REDISCLI_AUTH -ErrorAction SilentlyContinue }
    $output = & redis-cli -h 127.0.0.1 -p 16379 shutdown save 2>&1
    if ($LASTEXITCODE -ne 0 -or ($output -match 'ERR|NOAUTH|WRONGPASS')) { throw 'Redis 正常停止失败，请检查实例日志。' }
    Remove-Item -LiteralPath $pidFile
    Write-Host '练习版 Redis 已保存数据并停止。'
} finally {
    if ($null -eq $previousAuth) { Remove-Item Env:\REDISCLI_AUTH -ErrorAction SilentlyContinue }
    else { $env:REDISCLI_AUTH = $previousAuth }
}
