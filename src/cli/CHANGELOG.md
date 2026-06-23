# Changelog

## [v0.0.1] - 2026-06-23

### 新增
- **CLI**: Rust 命令行工具 `qtdata`，支持 blueprint/scope/quotation/delivery 四个命令
  - 每个命令读 Markdown 描述 → LLM 生成结构化输出（CUE/JSON）
  - 基于 `quanttide-agent` Rust crate 调 DeepSeek API
