$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$nginx = Join-Path $root 'nginx-1.18.0'
$pidFile = Join-Path $nginx 'logs/nginx.pid'
if (!(Test-Path -LiteralPath $pidFile)) { Write-Host '本练习版前端未运行。'; exit 0 }
$savedPid = [string](Get-Content -LiteralPath $pidFile -Raw)
if ($savedPid -notmatch '^\s*(\d+)\s*$') { Write-Host '本练习版前端未运行。'; exit 0 }
$existing = Get-Process -Id ([int]$Matches[1]) -ErrorAction SilentlyContinue
if (!$existing -or $existing.Path -ne (Join-Path $nginx 'nginx.exe')) { throw 'PID 与本练习版不匹配，未停止任何进程。' }
& (Join-Path $nginx 'nginx.exe') -p ($nginx.Replace('\','/') + '/') -c conf/nginx.conf -s quit
if ($LASTEXITCODE -ne 0) { throw '停止前端失败。' }
