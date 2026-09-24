# 量潮数据

数据业务仓库：把零散数据加工成可用的信息资产，以**可组合的积木**（而非整体平台）对外交付。当前状态见 [STATUS.md](./STATUS.md)。

## 仓库结构

```
src/cli/                 – Rust CLI：blueprint/scope/quotation/delivery 四命令
  src/main.rs            – 命令入口（读 Markdown → LLM → 结构化输出）
  ROADMAP.md             – 四阶段路线
src/provider/            – Python FastAPI 服务端
  app/                   – main（路由）+ storage（当前为内存存储）
  test/                  – 单元测试
src/studio/              – Flutter 客户端
  lib/screens/tabs/      – 详情页 5 Tab（总览/数据/项目/商务/资产）
  lib/widgets/           – 共享组件（cards / common / dialogs）
  assets/data/           – seed 数据（seed_projects.json）
src/site/                – React 19 + TypeScript + Vite 展示站
docs/                    – 工作文档
  dev-guide/             – 开发指南：stories/（按业务线拆解）+ prototype.html（实现原型）
tests/                   – 端到端测试（pytest + xdotool）
  screens/               – 页面层（Page Object）
  usecases/              – 用例层（pytest 业务序列）
  utils/                 – 工具层（BasePage、截图、录屏）
examples/                – 示例与原型
  dataset-api/           – 数据集 API 参考实现（Go）
  default/               – 默认示例
  prototype/             – 交互原型（HTML 快照）
scripts/                 – 运行脚本（run-studio-linux.sh）
.quanttide/journal/      – 按日期存档的会话记录
```

## 文档索引

| 文档 | 用途 |
|------|------|
| [STATUS.md](./STATUS.md) | 仓库快照：业务定位、组件进度、战略差距、ROADMAP 进度 |
| [AGENTS.md](./AGENTS.md) | 工作纪律与沟通原则 |
| `src/{cli,provider,studio,site}/ROADMAP.md` | 各组件路线图 |
| `docs/dev-guide/stories/index.md` | 业务线拆解（需求来源） |
| `tests/README.md` | 测试体系约定 |
| `src/{cli,provider,studio,site}/CHANGELOG.md` | 各组件版本记录 |
