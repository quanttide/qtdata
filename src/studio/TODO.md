# TODO：studio 待办（按张力求段）

每条写清三样：**改什么 / 判据（命令行可跑的）/ 影响哪些文件**。契约条款的出处见 [STATUS.md](./STATUS.md)。

**通用判据三连**（每条改动做完都要过）：

```bash
cd src/studio
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## 一、门禁（已落地 2026-09-24）

`deploy-studio.yml` 改成两作业形态，对齐 qtcloud-work 的 `release-studio.yml`：

- `quality-gates`——分支与 PR 上跑 `dart format --set-exit-if-changed --output=none .` + `flutter analyze` + `flutter test`
- `build-and-deploy`——`needs: quality-gates`，且只在 `studio/*` tag 上触发（分支推送只跑到门禁为止）

CI 首跑成功（run `35968122408`：Quality Gates 六步全绿，部署作业按设计 skipped）。`analysis_options.yaml` 同期加严并跑绿（strict 三条 + 三条规则，命中 2 处推断告警按告警改代码）。

**这一段没有欠账了**，往下见二～六段。

## 二、结构（借 Bloc 家法）——已落地 2026-09-24

五件都做完了（前三件 pi 执行，后一件 Hermes 执行；均经 Hermes 复验）：

- **正名**：`lib/widgets/` → `lib/views/`，撤掉 `cards/`／`common/`／`dialogs/` 三个按形状切的自造分组，12 个文件平铺进 `views/`；`test/widgets/` → `test/views/`（测试跟着分层）
- **拆模型**：`lib/models/project.dart` 377 行 → 6 个文件（`project` / `project_status` / `project_matrix` / `blueprint` / `project_phase` / `business_info`），只按现有类聚集拆，未改字段与 JSON 结构
- **拆越界件**：`business_tab.dart` 381 行 → 7 个文件（外壳 + 6 张卡）；`dashboard_screen.dart` 337 行 → 3 个；`matrix_card.dart` 303 行 → 2 个
- **横切集中一处**：新建 `CONTRIBUTING.md`，收口分层名义、选型现状、门禁三连、依赖规矩
- **分域（2026-09-24 追加）**：`lib/` 重排成四域 + 跨域——`project/`（9 文件）、`data/`（3）、`business/`（8）、`asset/`（5，收交付物与交付矩阵）、跨域 `app/`（10）；每个域内部保持 `models/ views/ screens/` 三层，`main.dart` 留根。`Deliverable` 从 `project/models/project.dart` 拆出归入 `asset/models/deliverable.dart`

**复验证据**：`flutter analyze` 零告警、`dart format` 无差异、`flutter test` 21/21 绿（Hermes 自己重跑，分域前后各一次）；最长文件由 381 降到 **235**（全部 <250）；测试断言数 105 → 105 未削弱；全 `lib/` 中文字面量 71 种一一对应、无增无减（行为不变的可比信号）。

**这段的两处命名动作**（超出「只改路径」，已认下）：跨文件搬出的私有类转公开（`_QuotationCard` → `QuotationCard` 等），以及 `_MatrixCell` → `MatrixDataCell`（与模型类 `MatrixCell` 撞名）。

**这段的一处自定**（偏离族里家法，写进约定文件）：界面部件那一层叫 `views/`——Bloc 官方示例用的是 `view/` + `widgets/` 两档，我们合成一层。

## 三、选型（默认选型成文）

**改什么**：状态管理落成显式声明——要么改用 Bloc（默认选型），要么在约定文件里写明继续用 `setState` 的理由。
**判据**：`grep -rn "bloc\|状态管理" src/studio/pubspec.yaml <约定文件>` 至少有一处说明；若改 Bloc，则 `pubspec.yaml` 出现 `flutter_bloc` 且 `lib/states/` 存在。
**影响**：`pubspec.yaml`、`lib/{域}/states/**`（新增）、各域的 `screens/**` 与 `views/**`（改建 Bloc 的话）。

**改什么**：路由改为 `go_router`（平台契约硬要求：Studio 路由统一使用 go_router），建路由表，保留现有 `?tab=` 深链行为。
**判据**：`pubspec.yaml` 含 `go_router`；`main.dart` 用 `MaterialApp.router`；`flutter test` 里深链用例通过。
**影响**：`pubspec.yaml`、`lib/main.dart`、`lib/project/screens/dashboard_screen.dart`、`lib/app/screens/project_detail_screen.dart`。

## 四、构建与发布

**改什么**：CanvasKit 自托管——CI 构建加 `FLUTTER_WEB_CANVASKIT_URL`，发布前在无代理网络验证一次。
**判据**：workflow 里出现该环境变量；无代理网络下打开线上页面不白屏。
**影响**：`.github/workflows/deploy-studio.yml`。

**改什么**：依赖许可清单成文（`cupertino_icons`、`flutter_lints`，以及后续新增的每一个）。
**判据**：约定文件或 README 里有一张「已许可依赖」表，与 `pubspec.yaml` 逐条对得上。
**影响**：`src/studio/README.md`（或约定文件）。

**改什么**：`data.quanttide.com` 的去向——它现在还指着 studio 桶，按家族惯例这个位置应该是 **site 的入口**（`src/site`，尚未部署）。现在两个域名都刷 studio 的缓存，是过渡态。
**判据**：定下它的去向：a) 改指 site 桶（那时把它的刷新从 studio workflow 摘掉，交给 site 的部署线）；b) 直接下线（DNS 与 CDN 侧删掉）。
**影响**：`.github/workflows/deploy-studio.yml`、DNS/CDN 侧（另需 `src/site` 的部署线）。

**改什么**：IaC 落地——建 `manifests/terraform/`，把 OSS 桶与 CDN 的现状写成代码。
**判据**：`src/studio/manifests/terraform/`（或 `apps/qtdata/manifests/terraform/`，归属待定）存在且 `terraform plan` 能跑出与线上一致的差异。
**影响**：新增 IaC 目录。

## 五、文字欠账

**改什么**：`README.md` 换掉 Flutter 模板原文，写成这个客户端的真说明（做什么、怎么跑、怎么发）。
**判据**：文件里不再出现 `flutter.dev/get-started` 之类模板链接。
**影响**：`src/studio/README.md`。

**改什么**：`ROADMAP.md` 与实现对齐（见本目录 ROADMAP，已重写）。
**判据**：ROADMAP 的分段表里每一项都能指到代码或明确指出「未做」。
**影响**：`src/studio/ROADMAP.md`。

**改什么**：`doc/` 是**页面分解产物**（Flutter 实现之前把两页拆成区块、交互、数据的那一版），保留；在 `doc/index.md` 开头补一句身份说明，免得后来者当成现行实现去对照。
**判据**：`doc/index.md` 开头写明「页面分解，非 Flutter 实现」。
**影响**：`src/studio/doc/index.md`。

## 六、平台与集成测试（都还不完善）

**改什么**：四个平台目录（android / ios / macos / windows）从建仓起**没有构建验证过**——逐平台跑一次构建，把残留的模板（应用名 `qtdata_studio`、包名、图标、启动页）改成本产品。
**判据**：每个平台 `flutter build <android|ios|macos|windows>` 能跑通；应用名与图标不再是 Flutter 默认值。
**影响**：`android/`、`ios/`、`macos/`、`windows/`、`pubspec.yaml`。

**改什么**：`integration_test/` 现在是空目录（`pubspec.yaml` 却已声明依赖）——补第一个真实用例，端到端走一条最短路径：启动 → 看板看到项目 → 进详情 → 切 Tab。
**判据**：`flutter test integration_test -d linux` 至少一个用例通过。
**影响**：`integration_test/`（新增用例）、`pubspec.yaml`。

**改什么**：划清两套测试的边界，别重复造——studio 的 `integration_test/` 管 **Flutter 进程内**（部件组合、页面流程）；仓库根 `tests/`（pytest + xdotool）管**跨进程端到端**（provider 启停 + 桌面窗口操作），跑的是 `run-studio-linux.sh` 那个 Linux 形态。
**判据**：两处各有一句边界说明，且没有同一个用例两边都写。
**影响**：`tests/README.md`、`integration_test/`（新增 README）。

## 七、界面数据（2026-09-24 换内容后新增）

**改什么**：seed 里的商务数字换成真实数字。现在 `assets/data/seed_projects.json` 的成本法 2.5 万、市场法 4.5 万、合同额 4.0 万、已收 2.0 万都是示例值（`pricingNote` 已注明非实际报价）。
**判据**：`grep -n "示例数据，非实际报价" src/studio/assets/data/seed_projects.json` 无输出；`flutter test` 仍 21/21。
**影响**：`assets/data/seed_projects.json`、`test/**`（依赖数字的断言：`project_card_test`、`project_detail_screen_test`）、`STATUS.md` 的界面数据表。

**改什么**：案例内容随案例库同步——gallery 的案例页改了（新增市场、增删监控维度、补案例），seed 要跟上。
**判据**：seed 的交付物／矩阵格／阶段名与 `docs/gallery/qtdata/` 的对应案例页逐条对得上。
**影响**：`assets/data/seed_projects.json`、相关测试断言。
