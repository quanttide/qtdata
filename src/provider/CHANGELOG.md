# Changelog

## [Unreleased]

文档重组：`docs/` 按 user-guide / dev-guide / api-references 三类收拢，原 `docs/usage.md` 与根部 `ROADMAP.md` 拆入其中。

### Changed

- `docs/user-guide/index.md`：启动、配置、真命令走一遍（原 `usage.md` 的使用部分）
- `docs/api-references/`：通用语义与错误码（`index.md`）+ 数据集 / 项目 / 任务各一篇字段与调用示例
- `docs/dev-guide/index.md`：目录落位、请求路径、加一个资源的步骤、存储抽象、服务边界（流程语义在 CLI，不在本服务）
- `docs/dev-guide/roadmap.md`：由根部 `ROADMAP.md` 移入，去掉流程 API 与资产 API 两节（归属错误，见 dev-guide·服务边界）
- `README.md`：加文档索引，启动段改指 `docs/user-guide/index.md`

## [provider/v0.1.0] - 2026-09-24

Go 重写：Python FastAPI → Go 全量迁移；`examples/dataset-api` 整合进 provider。

### Added

- 服务骨架：`cmd/server` 装配（config → store → 路由 → 日志 → 优雅关闭）
- 配置：`internal/config`，JSON 文件 + `QTDATA_*` 环境变量覆盖（兼容无前缀旧名）
- 存储：`internal/store` — Store 接口 + filestore（本地 JSON 持久化，S3 预留），替代内存 dict
- 数据集 CRUD：`/api/v1/qtdata/datasets`（自 `examples/dataset-api` 整合）
- 项目 CRUD：`/api/v1/qtdata/projects`（接续 Python 版 Project 能力）
- 任务 CRUD：`/api/v1/qtdata/tasks`（接续 Python 版 Task 能力）
- 统一错误响应 `{"error": {"code", "message"}}` 与 `log/slog` 日志

### Changed

- 路由统一挂载 `/api/v1/qtdata/*`（原 `/projects`、`/tasks` 无前缀）
- 创建返回 `201` 并由服务端分配 id；更新统一 `PUT`（原 `PATCH`）

### Removed

- Python 实现：`app/`、`test/`、`pyproject.toml`、`uv.lock`

### Tests

- store / api / config 单元测试，httptest 覆盖三资源 CRUD 与校验

## [provider/v0.0.1] - 2026-05-14

### 新增

- FastAPI 服务脚手架，基于 `fastapi-quanttide-project` 的 Project/Task CRUD 路由
- 服务端模块结构：`app/main.py` 入口 + 分层模块
- Provider-Studio 集成：API 客户端与数据看板状态同步
- Service 测试覆盖 provider 与 studio 对接场景
