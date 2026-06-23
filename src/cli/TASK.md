# Task: qtdata CLI 接入 quanttide-agent Rust crate

## 背景
qtdata CLI（Rust 项目）在 `apps/qtdata/src/cli/`。当前 `blueprint` 命令靠 subprocess 调 Python `quanttide_agent.LLM`，要改成直接加 Rust crate。

## 步骤
1. Cargo.toml 加依赖 `quanttide-agent = "0.1.0"`（从 crates.io 下载）
2. main.rs 改 `llm_call()`：import `quanttide_agent::LLM`，调 Rust API 代替 subprocess 调 python3
3. 验证 `cargo build` 通过
4. 快速验证 `cargo run -- blueprint -i <some.md> -o /tmp/test.cue` 能正常输出 CUE
5. 删除测试产物 `/tmp/test.cue`

## 约束
- 保持 `blueprint -i <input> -o <output>` 接口不变
- 保持 LLM prompt 逻辑不变（Markdown → CUE）
- `DEEPSEEK_API_KEY` 环境变量读法保持不变
- 删除 `AGENT_SRC` 常量和 subprocess 相关代码

完成后删除本文件。
