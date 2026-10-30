# 点评重写练习约定

用户正在复习 Java 后端与 Redis，希望由助手带着自己重写。
- 本轮目标是用户亲手重写业务，并走完 Git 版本管理、测试构建、阿里云部署、更新和回滚。Git 从重写前的工程基线开始，后续每个小任务验证后学习提交；不要替用户跳过学习步骤。
- 部署目标已确认：用户现有阿里云 ECS、Ubuntu，目前无网站或其他应用；系统具体版本、规格与连接方式待部署准备时核实。首轮学习手动部署，之后再学习自动化。
- 默认使用中文。先阅读 README.md、docs/开发说明.md 和 docs/学习进度.md。
- 这是练习工程。除非用户明确要求代写，不主动完成 TODO，也不一次实现多个模块。
- 带练时一次只推进一个小任务：说明输入输出、给必要提示、让用户写，再检查和解释。
- 不把未实现接口改成假成功；保留明确的待实现响应。
- 旧工程 D:/Projects/Java/DianPing 只作参考，不修改。
- 仅使用 dianping_practice 练习库；Redis key 统一以 dp:practice: 开头，不执行 FLUSHDB/FLUSHALL。
- 本机密码放在被忽略的 application-local.yaml，不能输出或提交。
- 验证通过后再更新 docs/学习进度.md，区分应用启动、依赖连通与业务完成。
- 脚本按使用者分目录：scripts/user 为用户日常入口；scripts/agent 为 Agent 后台入口。先阅读 scripts/README.md，不再使用原 scripts 根目录下的旧路径。
- Agent 后台启动后端使用 scripts/agent/start-backend.ps1，配套停止脚本必须校验 PID 和本工程 JAR；不要终止用户的 IDEA 或其他工程进程。
- 开发与部署学习路线见 docs/02-开发与部署流程.md；讲解路线不等于已经完成业务、发布配置或服务器部署。
