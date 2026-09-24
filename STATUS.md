# qtdata 状态报告

> 更新日期：2026-09-24
> 仓库：quanttide/qtdata
> 最新 commit：7f2e811 (2026-09-10)
> 版本记录：`src/cli/CHANGELOG.md`、`src/provider/CHANGELOG.md`、`src/studio/CHANGELOG.md`、`src/site/CHANGELOG.md`

## 业务定位（2026-09-04 确认）

qtdata 的业务模式是**组合积木**——可拼装、按需组合，而非整体平台。

与 qtcloud 的分界：帮企业替代飞书/企微、自建平台的「平台型需求」归 qtcloud（自建平台 + 卖标准品，执行云为落点）；「积木型需求」归 qtdata。商务需求按此边界归类，不能混为一谈。来源：`data/journal/qtdata/2026-09-04.md`。

## Scope 状态

| Scope | 目录 | 最新版本 | 状态 |
|-------|------|---------|------|
| CLI | `src/cli` | 0.1.0（无 tag，CHANGELOG 记 `v0.0.1`） | 骨架，2026-06-23 后未再改动 |
| Provider | `src/provider` | 0.1.0（Go 重写；tag `provider/v0.0.1` 为 Python 版） | Go 服务端，三资源 CRUD + filestore 持久化 |
| Studio | `src/studio` | 0.1.0-beta.4（2026-08-08） | 最新活跃组件，入口 `studio.data.quanttide.com` |
| Site | `src/site` | 0.1.0（2026-09-08，无 tag） | 首页已建，未部署 |

### CLI

Rust 命令行工具，四命令 blueprint / scope / quotation / delivery，均走同一条路径：读 Markdown 描述 → LLM（DeepSeek）→ 写结构化输出（CUE/JSON）。`src/main.rs` 46 行，四命令共用 `md_to_file()`，是骨架而非业务实现。最后一次功能改动 2026-06-23，此后仅 6-25 有一次仓库整理（`chore: 移除 target 目录跟踪，添加 STATUS.md`）。

### Provider

Go 服务端（stdlib net/http，模块 `qtdata-provider`）：`cmd/server` 装配 config / store / slog 日志 / 优雅关闭；领域路由挂 `/api/v1/qtdata/{datasets,projects,tasks}`，filestore 本地 JSON 持久化（重启不丢）；数据集域自 `examples/dataset-api` 整合（原自 qtadmin provider 拆出）。带 Go 单元测试与 `docs/usage.md`。

### Studio

Flutter 客户端。详情页为 5 Tab（总览/数据/项目/商务/资产）；`lib/` 按域分：**project / data / business / asset 四域 + 跨域 `app/`**（2026-09-24 落，每个域内 `models/ views/ screens/`）；数据来自 `assets/data/seed_projects.json`；已做移动端适配（<640px 隐藏侧栏）。最后发布 `studio/v0.1.0-beta.4`（2026-08-08）；入口 `studio.data.quanttide.com`（2026-09-24 起），CI 在 `studio/*` tag 上构建部署、分支与 PR 上跑门禁（format + analyze + test）。

### Site

React 19 + TypeScript + Vite 展示站，技术栈对齐 qtclass-site。首页含业务定位、服务对象、核心竞争力三段文案；部署链路（OSS + CDN）未做。

## 战略差距分析

来源三方对照：日志（`data/journal/qtdata/` 4 篇）、意图（`data/intention/qtdata/` 5 篇：connect/customer/dataops/growth/product）、实现（`src/`）。

### 尺子已经换了

2026-07 版报告按「平台化终局」量 qtdata，得出「三方平台、供给侧整合、定价权」等 100% 差距。**2026-09-04 边界确认后这些不再成立**：平台型需求归 qtcloud，qtdata 只做积木。旧报告里的那几项差距属于**边界外**，不是欠账。

按新边界重新量：

| 维度 | intention 要什么 | 实现层现在在哪 | 差距 |
|------|-----------------|---------------|------|
| **需求拆解** | 把模糊业务诉求变成可执行的工程任务 | CLI `blueprint`/`scope` 有命令，但只是 Markdown→结构化数据的 LLM 转换骨架 | 大：拆解方法论没有落地 |
| **过程管控** | 每一步有标准，每个交付物有验收准则 | CLI `delivery` 只有字段声明；无流程实例、无状态流转 | 大 |
| **质量兜底** | 出问题能回溯、归因、改进 | 无血缘、无记录、无工单 | 大 |
| **观测视角** | 正确视角是观测整个系统（AI 做事、人观测）；Project 是基本容器 | Studio 已按 5 Tab + 矩阵资产地图做出观测面，但数据来自 seed JSON | 中：**界面跑在数据模型前面** |
| **复现即成熟** | 不断复现过往事情，复现越多平台越成熟 | 无承载复现的工程件（无样本库、无处理流水线） | 大 |
| **积木化交付** | 以可组合模块交付 | 四个组件各自独立，无对外可拼装的模块边界 | 大 |
| **云转型漏斗** | 历史项目标准化上云，项目换成产品 | 实现层为零；按新边界，其中平台/云那一半归 qtcloud | 边界外（本仓不背） |

### 根因

实现层只覆盖了数据加工的最浅一段（Markdown→JSON 的 LLM 转换 + 看板展示），而意图描述的是**技术管理体系**——需求拆解、过程管控、质量兜底三件事都还停在意图层，没有落成代码或流程。缺口不是少写代码，是这三件事还没有可执行的定义。

外部侧已经先行：`2026-08-31`/`2026-09-04` 日志记录的真实课题（流程状态数据解析链路，基于 E1–E18 邮件工作流，自检 5/5 通过、已进 P1 真实数据验证）**比本仓实现走得更远**——它正是「把散在邮件里的流程状态抽成结构化数据」这条路，与本仓 `blueprint`/`delivery` 想做的事同源。

## ROADMAP 进度

| 文件 | 规划 | 与实现的符合度 |
|------|------|--------------|
| `src/cli/ROADMAP.md` | 四阶段：CLI 框架 → Scope → Quotation → Delivery | 全部未勾选；四命令已有骨架——ROADMAP 记的是「要做成什么」，实现停在骨架 |
| `src/studio/ROADMAP.md` | 新增 `qtdata-data`/`qtdata-asset` 包 + 页面路由 | 脱节：5 Tab 已上线，ROADMAP 仍写「增加数据页面、资产页面」 |
| `src/provider/ROADMAP.md` | 数据处理 API + 资产 API + 持久化 | 持久化已完成（filestore，2026-09-24 Go 重写）；数据处理与资产 API 未开始；包名写 `qtdata-process`，与 studio 的 `qtdata-data` 不一致 |
| `src/site/ROADMAP.md` | v0.1.0 首页 + 部署链路；v0.2.0 服务详情页 + 内容契约化 | 首页 ✅，其余未开始（唯一与实现对齐的 ROADMAP） |
| `tests/ROADMAP.md` | P2 基础设施（conftest/screens/utils）、P3 场景层 | 均未勾选 |
| `tests/screens/ROADMAP.md` | Project/Data/Asset 三个 Page Object 规格 | 规格已写，实现状态未标注 |

## 文档覆盖

| 目录/文件 | 状态 |
|----------|------|
| `docs/dev-guide/index.md` | 用户故事地图 + 4 篇场景（场景一/二/三/五）合并为单文件（2026-09-24；asset 移入 `src/studio/doc/`，business_line 移入主仓库 roadmap/qtadmin，stories/ 目录已移除） |
| `docs/dev-guide/prototype.html` | **已删除**（2026-09-24），原型由 `src/studio/doc/` 承接 |
| `docs/index.md` | 有 |
| `docs/{brd,prd,add,dev,ixd,drd,pmd}` | **已移除**（2026-08-08），由 `docs/dev-guide/` 承接 |
| `examples/` | **已移除**（2026-09-24：dataset-api 整合进 `src/provider`，prototype 与 default 已删除） |
| `tests/` | README + ROADMAP + conftest.py + screens/ + usecases/ + utils/ |
| `README.md` | 有（2026-09-24 按实际结构重写） |
| `CHANGELOG.md`（根） | 停在 0.0.1（2026-05-14），8 月以来变更只在各组件 CHANGELOG |

## 已知不一致（待处理）

1. CLI 的 ROADMAP 落后于实现（Studio 那份 2026-09-24 已按契约重写并补齐三件套）；Provider 与 Studio 的包名互不一致（`qtdata-process` vs `qtdata-data`）
2. CLI 自 2026-06-25 后无改动——它却是「需求拆解」唯一实现落点
3. Provider 无持久化 + Studio 用 seed JSON → 端到端跑不了真实数据链路
4. tag 与工程文件版本号不一致（CLI：无 tag / CHANGELOG 记 v0.0.1 / Cargo.toml 已是 0.1.0）
5. 仓库级 CHANGELOG 停在 0.0.1，未随 studio/site 发布更新
