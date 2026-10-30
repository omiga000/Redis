# 脚本使用说明

所有命令示例均在项目根目录 `D:/Projects/Java/Redis` 执行。脚本内部按自身位置计算根目录，因此从其他工作目录调用绝对路径也可以。

## 你日常使用：user

| 脚本 | 作用 | 停止方式 / 注意事项 |
| --- | --- | --- |
| `user/check-env.ps1` | 检查 Java、Maven 和四个本机端口 | 只读；端口可连接不代表认证或业务成功 |
| `user/start-redis.ps1` | 启动独立练习 Redis，端口 16379 | 使用 `.local/redis.conf`；PID 在 `.run/redis.pid` |
| `user/stop-redis.ps1` | 保存 Redis 数据并停止本练习实例 | 校验进程归属，不清空数据库 |
| `user/start-frontend.ps1` | 检查 Nginx 配置并后台启动前端，端口 18080 | 已有本练习前端时不重复启动 |
| `user/stop-frontend.ps1` | 正常停止本练习 Nginx | 校验 PID 和可执行文件路径 |
| `user/start-backend.ps1 [-Build]` | 在当前终端运行后端，端口 18081 | Ctrl+C 停止；优先用 IDEA 开发和调试 |

后端脚本带 `-Build` 或找不到 JAR 时运行 `mvn -DskipTests package`；否则使用已有 JAR。这个便捷构建跳过测试，不代表业务验证完成。改完 Java 后要重新构建，或者从 IDEA 重新运行。

### 日常启动顺序

1. 确保本机 MySQL 已启动；本工程脚本不管理 MySQL 服务。
2. 检查环境并启动练习 Redis：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\user\check-env.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\user\start-redis.ps1
```

3. IDEA 打开 `hm-dianping`，工作目录设为该目录，运行 `HmDianPingApplication`。或者在单独终端运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\user\start-backend.ps1 -Build
```

4. 另开终端启动前端，然后打开 `http://127.0.0.1:18080`：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\user\start-frontend.ps1
```

结束时先在 IDEA 或后端终端停止后端，再执行前端、Redis 的停止脚本。数据库初始化只在新环境首次准备时执行，日常开发不重复导入。

## Agent 后台使用：agent

| 脚本 | 作用 |
| --- | --- |
| `agent/start-backend.ps1 [-Build]` | 后台运行本工程 JAR，记录 PID，分别输出标准日志和错误日志，并检查应用状态接口 |
| `agent/stop-backend.ps1` | 根据 PID 和本工程 JAR 路径确认归属后停止后台后端 |

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\agent\start-backend.ps1 -Build
powershell -ExecutionPolicy Bypass -File .\scripts\agent\stop-backend.ps1
```

这两条是启、停示例，按需要分别执行。`-Build` 同样使用跳过测试的便捷构建。后台进程已存在时不自动重启；带 `-Build` 会提示先停止，以免继续运行旧版本。

运行记录为 `.run/backend.pid`、`.run/backend.out.log`、`.run/backend.err.log`。日志可能包含开发数据，分享前检查敏感信息。

Agent 需要准备 Redis 或前端时，可以复用 `user` 下的脚本；“按使用者分目录”用于区分入口和进程管理方式，并非权限限制。

### Agent 与 IDEA 之间交接

- Agent → 你：先执行 `agent/stop-backend.ps1`，再从 IDEA 启动。
- 你 → Agent：先在 IDEA 或前台终端停止后端，再由 Agent 后台启动。
- `user/start-backend.ps1` 不记录后台 PID；停止脚本不会代替 IDEA 的停止按钮。
- 端口被占用时先确认进程归属，不按端口批量杀进程。

## 调整说明

原 `scripts/*.ps1` 已迁入上述目录，旧路径不再保留。脚本向上查找项目根目录的层级已同步调整。新增的是 Agent 后台启动入口；业务代码和数据库结构不在本次整理范围内。

这些是 Windows 本机开发脚本。服务器部署的准备、发布与回滚流程见 [开发与部署流程](../docs/02-开发与部署流程.md)。
