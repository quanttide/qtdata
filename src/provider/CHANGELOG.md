# Changelog

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
