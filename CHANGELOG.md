# Changelog

## [Unreleased]

### 变更
- **Provider**: Python FastAPI → Go 全量重写（模块 `qtdata-provider`）：数据集/项目/任务 CRUD 统一挂 `/api/v1/qtdata/*`，filestore 本地 JSON 持久化，`cmd/server` 服务装配（config / slog / 优雅关闭）；`examples/dataset-api` 整合进 provider，`examples/` 目录移除

## [0.0.1] - 2026-05-14

### 新增
- **Provider**: FastAPI 服务端，支持 Project/Task CRUD，集成 `fastapi-quanttide-project`
- **Studio**: Flutter 数据服务看板客户端，支持需求探索→约定启动→执行监控→验收交付四列看板
- **E2E 测试**: 基于 xdotool + httpx 的端到端测试框架，覆盖 provider 启停、Flutter 窗口操作、截图/录屏
- **Service 测试**: provider 与 studio 对接场景测试
- 项目文档：PRD、BRD、架构设计、ROADMAP
