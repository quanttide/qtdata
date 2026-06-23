# Changelog

## [v0.0.1] - 2026-05-14

### 新增
- **Provider**: FastAPI 服务端，支持 Project/Task CRUD，集成 `fastapi-quanttide-project`
- **Studio**: Flutter 数据服务看板客户端，支持需求探索→约定启动→执行监控→验收交付四列看板
- **E2E 测试**: 基于 xdotool + httpx 的端到端测试框架，覆盖 provider 启停、Flutter 窗口操作、截图/录屏
- **Service 测试**: provider 与 studio 对接场景测试
- 项目文档：PRD、BRD、架构设计、ROADMAP

## [v0.0.2] - 2026-06-23

### 新增
- **CLI**: Rust 命令行工具 `qtdata`，支持 blueprint/scope/quotation/delivery 四个命令
  - 每个命令读 Markdown 描述 → LLM 生成结构化输出（CUE/JSON）
  - 基于 `quanttide-agent` Rust crate 调 DeepSeek API
