# Changelog

## [未发布]

### 变更
- **CLI 文档**：端根 `ROADMAP.md` 并入 `docs/dev-guide/roadmap.md` 后删除；新增 `docs/dev-guide/index.md`（代码落位、一次转换怎么走）。README 的四条验收标准移入路线图，README 改为指向。

## [v0.0.1] - 2026-06-23

### 新增
- **CLI**: Rust 命令行工具 `qtdata`，支持 blueprint/scope/quotation/delivery 四个命令
  - 每个命令读 Markdown 描述 → LLM 生成结构化输出（CUE/JSON）
  - 基于 `quanttide-agent` Rust crate 调 DeepSeek API
