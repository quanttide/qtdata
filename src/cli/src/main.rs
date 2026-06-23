use std::path::PathBuf;
use std::{env, fs};
use clap::Parser;
use quanttide_agent::llm::{LLM, CompleteOptions};
use quanttide_agent::message::Message;

#[derive(Parser)]
#[command(name = "qtdata")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Parser)]
enum Commands {
    Blueprint { #[arg(short)] input: PathBuf, #[arg(short)] output: PathBuf },
    Scope    { #[arg(short)] input: PathBuf, #[arg(short)] output: PathBuf },
    Quotation{ #[arg(short)] input: PathBuf, #[arg(short)] output: PathBuf },
    Delivery { #[arg(short)] input: PathBuf, #[arg(short)] output: PathBuf },
}

fn run_llm(md: &str, fmt: &str) -> Result<String, String> {
    let api_key = env::var("DEEPSEEK_API_KEY").map_err(|_| "DEEPSEEK_API_KEY 未设置".to_string())?;
    let llm = LLM::new("deepseek-v4-flash", "https://api.deepseek.com", &api_key);
    let msg = Message::new("user", &format!("将以下Markdown解析为{fmt}结构，只输出：\n{md}"));
    let opts = CompleteOptions { temperature: Some(0.1), ..Default::default() };
    llm.complete(&[msg], opts).map(|r| r.content).map_err(|e| format!("llm: {e}"))
}

fn md_to_file(input: PathBuf, output: PathBuf, fmt: &str) -> Result<(), String> {
    let md = fs::read_to_string(&input).map_err(|e| format!("read: {e}"))?;
    let content = run_llm(&md, fmt)?;
    fs::create_dir_all(output.parent().unwrap_or(&output)).map_err(|e| format!("mkdir: {e}"))?;
    fs::write(&output, &content).map_err(|e| format!("write: {e}"))?;
    println!("{}", content);
    Ok(())
}

fn main() -> Result<(), String> {
    match Cli::parse().command {
        Commands::Blueprint { input, output } => md_to_file(input, output, "CUE"),
        Commands::Scope     { input, output } => md_to_file(input, output, "JSON scope 字段：项目名称、目标、范围边界、交付物清单"),
        Commands::Quotation { input, output } => md_to_file(input, output, "JSON quotation 字段：工时分项、单价、总价、付款计划"),
        Commands::Delivery  { input, output } => md_to_file(input, output, "JSON delivery 字段：交付物ID、状态、验收标准"),
    }
}
