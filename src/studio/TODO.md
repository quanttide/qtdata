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

## 二、结构（借 Bloc 家法）

**改什么**：界面那一层正名 `widgets/` → `views/`，并撤掉按形状切的自造分组（`cards/` `common/` `dialogs/`）——形状不是层也不是聚合，家法里没有这三个名词。
**判据**：`ls src/studio/lib` 里没有 `widgets`；全仓 `grep -rn "widgets/" src/studio/lib src/studio/test` 无命中。
**影响**：`lib/widgets/**` 全部 12 个文件、`test/widgets/**` 8 个文件、`lib/screens/**` 的 import。

**改什么**：`lib/models/project.dart` 377 行装 12 个类，按聚合拆开（先按现状拆成多个文件，边界待模型来源定了再写实）。
**判据**：`find src/studio/lib -name "*.dart" -exec wc -l {} + | sort -rn | head -1` 的最大值 < 250。
**影响**：`lib/models/project.dart`（拆）、`lib/screens/**` 与 `test/**` 的 import。

**改什么**：`lib/screens/tabs/business_tab.dart` 381 行同上一并拆。
**判据**：同上一条；且 `flutter test` 全绿。
**影响**：`lib/screens/tabs/business_tab.dart`。

**改什么**：横切约定集中一处——新建本仓的开发约定文件，收口那些散在 README、`analysis_options.yaml`、文件头注释里的约束。
**判据**：文件存在，且 `docs/dev-guide/` 或仓库根能链到它；里面至少包含：分层名义、选型声明（见第三节）、门禁三连。
**影响**：新增 `src/studio/CONTRIBUTING.md`（或 `docs/dev-guide/studio.md`）。

## 三、选型（默认选型成文）

**改什么**：状态管理落成显式声明——要么改用 Bloc（默认选型），要么在约定文件里写明继续用 `setState` 的理由。
**判据**：`grep -rn "bloc\|状态管理" src/studio/pubspec.yaml <约定文件>` 至少有一处说明；若改 Bloc，则 `pubspec.yaml` 出现 `flutter_bloc` 且 `lib/states/` 存在。
**影响**：`pubspec.yaml`、`lib/states/**`（新增）、`lib/screens/**`（改建 Bloc 的话）。

**改什么**：路由改为 `go_router`（平台契约硬要求：Studio 路由统一使用 go_router），建路由表，保留现有 `?tab=` 深链行为。
**判据**：`pubspec.yaml` 含 `go_router`；`main.dart` 用 `MaterialApp.router`；`flutter test` 里深链用例通过。
**影响**：`pubspec.yaml`、`lib/main.dart`、`lib/screens/dashboard_screen.dart`、`lib/screens/project_detail_screen.dart`。

## 四、构建与发布

**改什么**：CanvasKit 自托管——CI 构建加 `FLUTTER_WEB_CANVASKIT_URL`，发布前在无代理网络验证一次。
**判据**：workflow 里出现该环境变量；无代理网络下打开线上页面不白屏。
**影响**：`.github/workflows/deploy-studio.yml`。

**改什么**：依赖许可清单成文（`cupertino_icons`、`flutter_lints`，以及后续新增的每一个）。
**判据**：约定文件或 README 里有一张「已许可依赖」表，与 `pubspec.yaml` 逐条对得上。
**影响**：`src/studio/README.md`（或约定文件）。

**改什么**：正式域名接入——CDN 刷新列表加 `data.cloud.quanttide.com`（现在只刷兼容入口 `data.quanttide.com`）。
**判据**：workflow 的域名列表里两条都在；两个域名都能打开同一版本。
**影响**：`.github/workflows/deploy-studio.yml`（另需 DNS／CDN 侧配置）。

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
