# 状态：studio 对照软件工程契约

体检日 2026-09-24（二段正名与拆分之后）。条款来自契约原型（结构契约、依赖契约、阶段条款）与 code 手册的工作平台契约。

- 契约原型：`domains/quanttide-code/data/insight/code-agent/contract.md`
- 平台契约：`domains/quanttide-code/docs/gallery/categories/platform/index.md`

## 规模

| 项 | 数 |
|---|---|
| `lib/` Dart 文件 | 35 |
| `lib/` 总行数 | 2961 |
| 分层 | `views/` 21 文件 1914 行、`screens/` 7 文件 636 行（其中 `tabs/` 5 文件 240 行）、`models/` 6 文件 382 行 |
| 最长的五件 | `views/project_card.dart` 235、`screens/project_detail_screen.dart` 210、`views/timeline_card.dart` 192、`screens/dashboard_screen.dart` 186、`views/project_filters.dart` 178——**全部 <250** |
| `test/` | 12 个文件 21 个用例，与 `lib/` 同构：`views/` 8、`screens/` 3、`helpers/` 1 |
| 门禁实况（2026-09-24） | 三条**已进 CI**（`deploy-studio.yml` 的 `quality-gates`：format + analyze + test，分支与 PR 触发、tag 才部署；首跑 run `35968122408` success）；本地同版（Flutter 3.44.9）三条全绿 |
| 运行时依赖 | 2 个：`flutter`、`cupertino_icons` |
| `doc/` | 页面分解产物（index/project 两页 + 4 个 js + 样式表），Flutter 实现之前的设计版 |
| `integration_test/` | 空目录——`pubspec.yaml` 的依赖已声明，无用例 |
| 平台目录 | 6 个共 122 个跟踪文件：ios 40 / macos 28 / android 19 / windows 18 / linux 10 / web 7。**web 是产品形态、linux 是本地调试形态**（`scripts/run-studio-linux.sh`），其余四个建仓起未构建验证 |

## 结构契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 借家法要连命名一起借（界面那一层叫 `views/`） | `lib/views/` 21 个文件平铺，无形状子目录（原 `widgets/{cards,common,dialogs}` 已撤） | ✓ 2026-09-24 正名 |
| 按 Bloc 家法分层（`repositories/` `states/` `screens/` `views/`） | 有 `screens/`、`views/`；**无 `repositories/`、无 `states/`**，状态用 `StatefulWidget` + `setState` | ✗ 缺两层（四段） |
| 不留第二份模型（界面直接用领域对象） | `lib/models/` 6 个文件 382 行，界面自留一份 | ✗ 来源待定（ROADMAP 待决） |
| 单文件行数越界即触发转聚合（同层单文件 >250 行） | 最长 235 行，无越界 | ✓ 2026-09-24 拆完 |
| 同一目录不得混用层名与聚合名（硬禁） | `lib/` 下全是层名，无聚合名——停在第一阶段，**未触犯** | ✓ |
| 测试跟着分层 | `test/{views,screens,helpers}` 与 `lib/` 同名同构 | ✓ |
| 组装与实现分离 | `main.dart` 29 行只装配 `MaterialApp` | ✓ |
| 横切约束集中一处 | `CONTRIBUTING.md` 收口分层名义、选型、门禁、依赖规矩（2026-09-24 建） | ✓ |

## 依赖契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 抽出去必须发布、按版本号引（挂本地路径不算） | 无外部自研包可引——qtdata 没有 toolkit，模型只能自留，与「不留第二份模型」互为因果 | ✗ |
| 外部依赖先看官方 SDK | 未接入任何外部系统 | — 不适用 |
| 默认选型成文（Bloc / go_router / Material） | Material 3 ✓；Bloc ✗（用 `setState`，项目内选型未声明）；go_router ✗（`MaterialApp(home:)` 直挂，无路由表） | ✗ 两项未对齐 |
| 外部依赖的坑写进契约（CanvasKit 自托管） | CI 构建无 `FLUTTER_WEB_CANVASKIT_URL` | ✗ 未落 |
| 依赖许可清单 | 无一处列明已许可依赖（`cupertino_icons`、`flutter_lints`） | ✗ 缺 |
| 一条发布线一个语言包 | tag `studio/*` 一条线发布 | ✓ |

## 平台契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 技术栈按角色（Studio = Flutter） | Flutter Web，`flutter build web` | ✓ |
| 路由统一使用 go_router | 无路由表，`MaterialApp(home:)` 直挂 | ✗ 未对齐（三段） |
| 桶命名 `{产品线}-{用途}` | `qtdata-studio` | ✓ |
| 域名 | **入口 `studio.data.quanttide.com`**（2026-09-24 起：CDN 域名 + DNS CNAME + 单域名证书 + 私有回源 + 根改写 + TLS1.3）；`data.quanttide.com` 仍指同一个桶，两个域名都刷缓存 | ✓ 与家族惯例一致（qtclass 用 `studio.class.quanttide.com`）——但**契约正文只写了 `{产品}.cloud.quanttide.com`，没写 studio 子域这条惯例，待补** |
| IaC 目录 `manifests/terraform/` | qtdata 下无 `manifests/` | ✗ 缺 |
| 门禁：Dart = `dart format` + `flutter analyze`，本地从严与 CI 一致 | 三条进 CI（分支/PR 跑门禁、tag 才部署）；本地与 CI 同版 Flutter 3.44.9 | ✓ 2026-09-24 |
| 可观测与安全（结构化审计日志 + SLS；密码 PBKDF2） | 无后端、无认证、无密码 | — 豁免 |

## 与工作流的对照

`domains/quanttide-work/docs/gallery/workflows/code-implement-studio.yaml` 是 qtcloud-work 专用（把命令行行为用 Dart 再实现，拿 `parity.sh` 对表）——qtdata 没有命令行行为要对表，**不适用**。

它的两条判据（`flutter analyze` / `flutter test`）已由本仓 CI 承接。本仓仍**没有自己的开发工作流**。

## 一句话

二段之后，结构与门禁都立住了：`views/` 正名、越界文件拆完（最长 235 行）、约定集中在一处、三条门禁进 CI。剩下的差距是**接通**——没有 `repositories/`、没有 `states/`、没有路由表、模型自留一份，界面仍跑在 seed JSON 上。
