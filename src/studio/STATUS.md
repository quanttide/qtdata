# 状态：studio 对照软件工程契约

体检日 2026-09-24（二段正名与拆分之后）。条款来自契约原型（结构契约、依赖契约、阶段条款）与 code 手册的工作平台契约。

- 契约原型：`domains/quanttide-code/data/insight/code-agent/contract.md`
- 平台契约：`domains/quanttide-code/docs/gallery/categories/platform/index.md`

## 规模

| 项 | 数 |
|---|---|
| `lib/` Dart 文件 | 39（含 `main.dart`） |
| `lib/` 总行数 | 3155 |
| 分域 | `project/` 10 文件 1166 行、`app/`（跨域）12 文件 827 行、`business/` 8 文件 479 行、`asset/` 5 文件 432 行、`data/` 3 文件 222 行、`main.dart` 29 行 |
| 最长的五件 | `project/views/project_card.dart` 235、`project/screens/dashboard_screen.dart` 193、`project/views/timeline_card.dart` 192、`project/views/project_filters.dart` 178、`asset/views/matrix_card.dart` 171——**全部 <250** |
| `test/` | 13 个文件 26 个用例（含 `test/app/router_test.dart` 深链 5 例），与 `lib/` 同名同构 + 跨域路由用例；另有 `integration_test/` 1 例真跑 Linux（启动→看板→详情→切 Tab） |
| 门禁实况（2026-09-24） | 四条**已进 CI**（`quality-gates`：format + analyze + test + 字体字符检查 `tool/check_font_chars.py`，分支与 PR 触发、tag 才部署）；本地同版（Flutter 3.44.9）四条全绿，`flutter test` 26/26 |
| 运行时依赖 | 3 个：`flutter`、`cupertino_icons`、`go_router` |
| 自带字体 | `fonts/` Noto Sans SC 子集四档（400/500/600/700，~166KB/档，667 字符源 + 6 个 emoji 字形合并），文字渲染不依赖 fonts.gstatic.com；字符门禁拦子集外新字符 |
| `doc/` | 页面分解产物（index/project 两页 + 4 个 js + 样式表），Flutter 实现之前的设计版 |
| `integration_test/` | 1 例真跑绿（`flutter test integration_test -d linux`）：启动 → 看板 → 详情 → 切资产 Tab；边界见其 README |
| 平台目录 | 6 个共 122 个跟踪文件：ios 40 / macos 28 / android 19 / windows 18 / linux 10 / web 7。**web 是产品形态、linux 是本地调试形态**（`scripts/run-studio-linux.sh`），其余四个建仓起未构建验证 |

## 结构契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 界面层命名（契约案例要求 `views/`） | 四个域各有 `views/`；**这是本项目约定**——Bloc 官方材料用的是 `view/` + `widgets/` 两档，全仓示例里 0 处 `views/`，故契约那条案例的「按 Bloc 惯例该叫 views/」站不住 | ⚠ 约定在用，契约案例待修 |
| 文件归属（域） | `lib/` 分四域 `project/ data/ business/ asset/` + 跨域 `app/`，每文件只属一域（2026-09-24 落） | ✓ |
| 按 Bloc 家法分层（`repositories/` `states/` `screens/` `views/`） | 域内有 `models/`、`views/`、`screens/`；**无 `repositories/`、无 `states/`**，状态用 `StatefulWidget` + `setState` | ✗ 缺两层（四段） |
| 不留第二份模型（界面直接用领域对象） | 各域 `models/` 自留一份（app 1、data 1、project 2、business 1、asset 2）；`Deliverable` 已从项目域归入资产域 | ✗ 来源待定（ROADMAP 待决） |
| 单文件行数越界即触发转聚合（同层单文件 >250 行） | 最长 235 行，无越界 | ✓ 2026-09-24 拆完 |
| 同一目录不得混用层名与聚合名（硬禁） | `lib/` 下全是层名，无聚合名——停在第一阶段，**未触犯** | ✓ |
| 测试跟着分层 | `test/{app,data,project,business,asset}/{views,screens}` 与 `lib/` 同名同构，跨域测试基础设施在 `test/helpers/` | ✓ |
| 组装与实现分离 | `main.dart` 29 行只装配 `MaterialApp` | ✓ |
| 横切约束集中一处 | `CONTRIBUTING.md` 收口分层名义、选型、门禁、依赖规矩（2026-09-24 建） | ✓ |

## 依赖契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 抽出去必须发布、按版本号引（挂本地路径不算） | 无外部自研包可引——qtdata 没有 toolkit，模型只能自留，与「不留第二份模型」互为因果 | ✗ |
| 外部依赖先看官方 SDK | 未接入任何外部系统 | — 不适用 |
| 默认选型成文（Bloc / go_router / Material） | Material 3 ✓；go_router ✓（^18，`lib/app/router.dart` 路由表 + `?tab=` 深链）；状态管理显式声明：0.1.0 用 `setState`，偏离 Bloc 的理由成文（CONTRIBUTING 选型段） | ✓ 2026-09-24 |
| 外部依赖的坑写进契约（CanvasKit 自托管） | 构建 `--no-web-resources-cdn`（`useLocalCanvasKit`，仓内 `canvaskit/`）；验收脚本 `scripts/check-web-gstatic-blocked.mjs`（屏蔽 gstatic 不白屏） | ✓ 2026-09-24（rc.2/3） |
| 依赖许可清单 | `CONTRIBUTING.md` 依赖段五行列明（含新增 `go_router`），与 pubspec 对得上 | ✓ 2026-09-24 |
| 一条发布线一个语言包 | tag `studio/*` 一条线发布 | ✓ |

## 平台契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 技术栈按角色（Studio = Flutter） | Flutter Web，`flutter build web` | ✓ |
| 路由统一使用 go_router | `lib/app/router.dart` 的 `buildRouter()`：`/` 列表 + `/projects/:id?tab=<slug>` 深链，`main.dart` 用 `MaterialApp.router`，深链/未知 id 用例 5 个 | ✓ 2026-09-24 |
| 桶命名 `{产品线}-{用途}` | `qtdata-studio` | ✓ |
| 域名 | **入口 `studio.data.quanttide.com`**（2026-09-24 起：CDN 域名 + DNS CNAME + 单域名证书 + 私有回源 + 根改写 + TLS1.3）；`data.quanttide.com` 仍指同一个桶，两个域名都刷缓存 | ✓ 与家族惯例一致（qtclass 用 `studio.class.quanttide.com`）——但**契约正文只写了 `{产品}.cloud.quanttide.com`，没写 studio 子域这条惯例，待补** |
| IaC 目录 `manifests/terraform/` | qtdata 下无 `manifests/` | ✗ 缺 |
| 门禁：Dart = `dart format` + `flutter analyze`，本地从严与 CI 一致 | format + analyze + test + 字体字符四条进 CI（分支/PR 跑门禁、tag 才部署）；本地与 CI 同版 Flutter 3.44.9 | ✓ 2026-09-24 |
| 可观测与安全（结构化审计日志 + SLS；密码 PBKDF2） | 无后端、无认证、无密码 | — 豁免 |

## 界面数据

| 项 | 现状 |
|---|---|
| 来源 | 仓库内手写 seed `assets/data/seed_projects.json`（尚未接通 Provider） |
| 内容 | 2026-09-24 由内部项目换成**真实案例**：全球法规情报中心（采集案例原始需求）——16 个市场、八类监控维度、官方来源优先；矩阵 3 维 × 5 阶段 15 格、交付物 4 项、时间线 6 阶段 14 项 |
| 商务数字 | **示例值**（成本法 2.5 万、市场法 4.5 万、合同额 4.0 万、已收 2.0 万），非实际报价，待商务确认后替换——见 [TODO](TODO.md) 七 |
| 断言同步 | 13 个测试文件按内容耦合点同步（项目名／客户／状态／日期／交付物计数／阶段名／矩阵格名／蓝图关键词／结款文案）+ 深链/路由用例，`flutter test` 26/26 绿；integration 首例 Linux 真跑绿 |

## 与工作流的对照

`domains/quanttide-work/docs/gallery/workflows/code-implement-studio.yaml` 是 qtcloud-work 专用（把命令行行为用 Dart 再实现，拿 `parity.sh` 对表）——qtdata 没有命令行行为要对表，**不适用**。

它的两条判据（`flutter analyze` / `flutter test`）已由本仓 CI 承接。本仓仍**没有自己的开发工作流**。

## 一句话

二段之后，结构又往前走三步（2026-09-24）：`lib/` 按**域**重排四域 + 跨域 `app/`；约定集中在 `CONTRIBUTING.md`；**段三选型已落**——go_router 路由表与 `?tab=` 深链、状态选型显式成文（`setState` + 理由）、自带字体 + 字体字符门禁、`integration_test` 首例真跑绿。剩下的差距是**接通**——域内没有 `repositories/`／`states/`、模型自留一份、界面仍跑在 seed JSON 上（段四拍板：0.1.0 以展示件口径发布）；交付形态侧还欠 IaC（`manifests/terraform/`）与 `data.quanttide.com` 去向。
