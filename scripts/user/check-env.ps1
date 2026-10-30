$ErrorActionPreference = 'Continue'
# 仅检查工具和端口，不启动或停止服务。
foreach ($command in @('java','mvn')) {
    $found = Get-Command $command -ErrorAction SilentlyContinue
    if ($found) { Write-Output "$command : $($found.Source)" } else { Write-Output "$command : 未找到，请检查 PATH" }
}
foreach ($port in @(3306,16379,18081,18080)) {
    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $pending = $client.ConnectAsync('127.0.0.1', $port)
        if ($pending.Wait(1000) -and $client.Connected) { Write-Output "$port : 端口可连接" }
        else { Write-Output "$port : 端口未连接" }
    } catch { Write-Output "$port : 端口未连接" } finally { $client.Dispose() }
}
Write-Output '端口可连接不代表认证成功。请继续验证商户查询，以及第一课中的 Redis 操作。'

