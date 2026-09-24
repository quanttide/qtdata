# 量潮数据

数据业务仓库：把零散数据加工成可用的信息资产，以**可组合的积木**（而非整体平台）对外交付。当前状态见 [STATUS.md](./STATUS.md)。

## 仓库结构

```
src/cli/                 – Rust CLI：blueprint/scope/quotation/delivery 四命令
  src/main.rs            – 命令入口（读 Markdown → LLM → 结构化输出）
  ROADMAP.md             – 四阶段路线
src/provider/            – Go 服务端（qtdata-provider）
  cmd/server/            – 服务装配（config / store / 路由 / 优雅关闭）
  internal/              – api（三资源 CRUD）/ config / model / store / version
src/studio/              – Flutter 客户端
  lib/screens/tabs/      – 详情页 5 Tab（总览/数据/项目/商务/资产）
  lib/widgets/           – 共享组件（cards / common / dialogs）
  assets/data/           – seed 数据（seed_projects.json）
src/site/                – React 19 + TypeScript + Vite 展示站
docs/                    – 工作文档
  dev-guide/             – 开发指南：用户故事地图与业务线场景（单文件）
tests/                   – 端到端测试（pytest + xdotool）
  screens/               – 页面层（Page Object）
  usecases/              – 用例层（pytest 业务序列）
  utils/                 – 工具层（BasePage、截图、录屏）

scripts/                 – 运行脚本（run-studio-linux.sh）
```

## 文档索引

| 文档 | 用途 |
|------|------|
| [STATUS.md](./STATUS.md) | 仓库快照：业务定位、组件进度、战略差距、ROADMAP 进度 |
| [AGENTS.md](./AGENTS.md) | 工作纪律与沟通原则 |
| `src/{cli,provider,studio,site}/ROADMAP.md` | 各组件路线图 |
| `docs/dev-guide/index.md` | 业务线拆解（用户故事地图与五篇场景，需求来源） |
| `tests/README.md` | 测试体系约定 |
| `src/{cli,provider,studio,site}/CHANGELOG.md` | 各组件版本记录 |
