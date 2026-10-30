# 点评后端重写练习

项目位置：`D:/Projects/Java/Redis`。沿用旧工程素材，从验证码和登录重新练起。

本轮目标：亲手重写业务逻辑，同时走完 Git、验证、构建、部署、更新与回滚。部署目标是已有的阿里云 ECS（Ubuntu，目前无其他应用）。先建立 Git 工程基线，再开始业务重写；第一段业务完成后开始实际部署，之后持续迭代发布。

开始阅读：
1. [开发说明](docs/开发说明.md)：环境、启动、目录与阶段安排。
2. [第一课：验证码与登录](docs/01-验证码与登录.md)：先只做 P1-01。
3. [学习进度](docs/学习进度.md)：逐项记录验证证据。
4. [验证记录](docs/验证记录.md)：助手准备工程时实际完成的检查。
5. [脚本使用说明](scripts/README.md)：区分你日常使用和 Agent 后台使用的脚本。
6. [开发与部署流程](docs/02-开发与部署流程.md)：从一个小需求到测试、打包、部署和回滚的学习路线。

| 目录 | 内容 |
| --- | --- |
| hm-dianping | Maven 后端工程，IDEA 导入这个目录 |
| nginx-1.18.0 | 原课程前端及本地 Nginx |
| database | 独立练习库初始化 SQL |
| docs | 开发说明、第一课与学习进度 |
| scripts/user | 你使用的环境检查、Redis/前端启停、后端前台运行脚本 |
| scripts/agent | Agent 使用的后端后台启停脚本，记录 PID 和日志 |

后端 `http://127.0.0.1:18081`；前端 `http://127.0.0.1:18080`。
第一步修改 `UserServiceImpl.sendCode`。待实现接口返回 success=false 是练习起点的预期结果。
不要把 application-local.yaml 中的密码分享出去。应用启动不会自动初始化数据库。

日常开发优先在 IDEA 启动后端。在项目根目录执行下面的命令，准备环境和前端：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\user\check-env.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\user\start-redis.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\user\start-frontend.ps1
```

MySQL 需先自行启动；检查脚本只检查工具和端口。后端若已由 Agent 在后台启动，先用 `scripts/agent/stop-backend.ps1` 交接，再从 IDEA 运行。
