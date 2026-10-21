# 开发指南

`qtdata` 是数据云的命令行工具。输入是 Markdown，输出是结构化数据（CUE / JSON）；转换由 LLM 完成，提示词与写盘逻辑都在 `src/main.rs`。

命令怎么用、四个命令各管什么，见 [README](../../README.md)。当前实现状态、待办与目标数据结构见 [路线图](roadmap.md)。

## 代码落位

```text
src/cli/
├── src/main.rs     全部实现：clap 定义四个子命令 + run_llm（DeepSeek）+ md_to_file（读 Markdown、写目标文件）
├── Cargo.toml      依赖 clap 与 quanttide-agent（LLM 客户端）
├── docs/dev-guide/ 本文与路线图
├── README.md       用法与命令结构
└── CHANGELOG.md    变更记录
```

## 一次转换怎么走

`qtdata blueprint --input <md> --output <file>` → clap 解析出子命令 → `md_to_file` 读入 Markdown → `run_llm` 以「将以下 Markdown 解析为 CUE 结构，只输出结果」调 DeepSeek（`DEEPSEEK_API_KEY` 必需）→ 建父目录、写文件、把内容打到标准输出。

无状态：不读缓存、不记历史、不校验产出形状。四个子命令的唯一差别是提示词里的目标格式。

## 文档怎么分

使用与命令结构在 README；实现现状、待办与目标结构在本目录。用户侧目前没有独立手册——这份 CLI 还处在「四命令能转格式、目录结构未落地」的阶段，写使用手册会先于实现。
