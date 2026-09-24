# 状态：studio 对照软件工程契约

体检日 2026-09-24。条款来自契约原型（结构契约、依赖契约、阶段条款）与 code 手册的工作平台契约。

- 契约原型：`domains/quanttide-code/data/insight/code-agent/contract.md`
- 平台契约：`domains/quanttide-code/docs/gallery/categories/platform/index.md`

## 规模

| 项 | 数 |
|---|---|
| `lib/` Dart 文件 | 21 |
| `lib/` 总行数 | 2833 |
| 最长的四个文件 | `screens/tabs/business_tab.dart` 381、`models/project.dart` 377、`screens/dashboard_screen.dart` 335、`widgets/cards/matrix_card.dart` 303 |
| `test/` | 12 个文件 21 个用例，与 `lib/` 同构：`widgets/` 8、`screens/` 3、`helpers/` 1 |
| 门禁实况（2026-09-24 实测） | `flutter analyze` 零告警、`dart format --set-exit-if-changed` 无差异、`flutter test` 21 个用例全绿——**用 Flutter 3.44.9 跑的，CI 也钉 3.44.9**（本地与 CI 同版）；但**三条都还没进 CI**，全靠手工跑 |
| 运行时依赖 | 2 个：`flutter`、`cupertino_icons`（无网络、无状态管理、无本地存储） |
| `doc/` | 页面分解产物（index/project 两页 + 4 个 js + 样式表），Flutter 实现之前的设计版 |
| `integration_test/` | 空目录——`pubspec.yaml` 的依赖已声明，无用例 |
| 平台目录 | 6 个共 122 个跟踪文件：ios 40 / macos 28 / android 19 / windows 18 / linux 10 / web 7。**web 是产品形态、linux 是本地调试形态**（`scripts/run-studio-linux.sh`），其余四个建仓起未构建验证 |

## 结构契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 借家法要连命名一起借（界面那一层按 Bloc 家法叫 `views/`） | 叫 `widgets/`，且再按形状切成 `cards/` `common/` `dialogs/` 三个子目录 | ✗ 待正名 |
| 按 Bloc 家法分层（`repositories/` `states/` `screens/` `views/`） | 无 `repositories/`、无 `states/`；状态用 `StatefulWidget` + `setState`（集中在 `dashboard_screen.dart`） | ✗ 未对齐 |
| 不留第二份模型（界面直接用领域对象） | `lib/models/project.dart` 377 行装 12 个模型类，界面自留一份 | ✗ |
| 单文件行数越界即触发转聚合（同层单文件 >250 行） | 4 个文件越界，最长 381 | ✗ 已触发 |
| 同一目录不得混用层名与聚合名（硬禁） | `lib/` 下全是层名／形状名，无聚合名——停在第一阶段，**未触犯** | ✓ |
| 测试跟着分层 | `test/{widgets,screens,helpers}` 与 `lib/{widgets,screens}` 同构 | ✓ |
| 组装与实现分离 | `main.dart` 29 行只装配 `MaterialApp`，界面在 `screens/` | ✓ |
| 横切约束集中一处 | 无约定文件；`analysis_options.yaml` 已加严（strict-casts／strict-inference／strict-raw-types + 三条规则），约束仍散在 README 与注释里 | ✗ 缺 |

## 依赖契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 抽出去必须发布、按版本号引（挂本地路径不算） | 无外部自研包可引——qtdata 没有 toolkit，模型只能自留，与「不留第二份模型」互为因果 | ✗ |
| 外部依赖先看官方 SDK | 未接入任何外部系统 | — 不适用 |
| 默认选型成文（Bloc / go_router / Material） | Material ✓；Bloc ✗（用 `setState`）；go_router ✗（`MaterialApp` 直挂 `home`，无路由表） | ✗ 两项未对齐 |
| 外部依赖的坑写进契约（CanvasKit 自托管，发布前须在无代理网络验证） | CI 构建无 `FLUTTER_WEB_CANVASKIT_URL` | ✗ 未落 |
| 依赖许可清单 | 无一处列明已许可依赖（`cupertino_icons`、`flutter_lints`） | ✗ 缺 |
| 一条发布线一个语言包 | tag `studio/*` 一条线发布 | ✓ |

## 平台契约

| 条款 | 现状 | 判定 |
|---|---|---|
| 技术栈按角色（Studio = Flutter） | Flutter Web，`flutter build web` | ✓ |
| 路由统一使用 go_router | 无路由表，`MaterialApp(home:)` 直挂看板；`?tab=` 深链靠 Web 端 URL | ✗ 未对齐 |
| 桶命名 `{产品线}-{用途}` | `qtdata-studio` | ✓ |
| 域名 `{产品}.cloud.quanttide.com` | 部署脚本只刷 `data.quanttide.com`（迁移期兼容入口） | ✗ 正式域名未接 |
| IaC 目录 `manifests/terraform/` | qtdata 下无 `manifests/` | ✗ 缺 |
| 门禁：Dart = `dart format` + `flutter analyze`，本地从严与 CI 一致 | 本地只有模板 lint 配置；CI（`deploy-studio.yml`）只 `pub get` + `build web`，不跑 format／analyze／test | ✗ 缺门禁 |
| 可观测与安全（结构化审计日志 + SLS；密码 PBKDF2） | 无后端、无认证、无密码 | — 豁免 |

## 与工作流的对照

`domains/quanttide-work/docs/gallery/workflows/code-implement-studio.yaml` 是 qtcloud-work 专用（把命令行行为用 Dart 再实现一遍，拿 `parity.sh` 对表）——qtdata 没有命令行行为要对表，**该工作流不适用**。

但它的两条判据对任何 studio 都通用，值得直接借：`flutter analyze` 与 `flutter test`。qtdata 侧现在**两条都没有**，本仓也没有任何工作流。

## 一句话

Studio 是「能看不能连」的展示件：界面看着整齐，但没有 `repositories/`／`states/` 两层、没有路由表、没有网络依赖、模型自留一份，CI 也不跑门禁。差距集中在**借家法**与**门禁**两处，不在功能。
