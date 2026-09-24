# Studio ROADMAP

## 为什么做

Studio 是 qtdata 的**观测面**：意图里写得很清楚——「平台的正确视角是观测整个系统，而不是思考流程」，假设 AI 做事、人观测，那么客户端就是给人看进度的那个面。「项目是平台的基本容器」，所以观测的单位是项目。

现在它是一个**能看不能连**的展示件：界面（5 Tab + 矩阵资产地图）已经画出来了，但数据来自仓库里一份手写的 seed JSON，既没有网络层，也没有路由表，连 CI 都不跑门禁。所以下一步不是加页面，是让它**站得住、连得上**。

体检与条款对照见 [STATUS.md](./STATUS.md)，逐条待办见 [TODO.md](./TODO.md)。

## 目标

从「展示件」到「能连真实数据的客户端」：结构按 Bloc 家法立住，门禁可跑，数据从 seed JSON 换成 Provider。

## 分段表

| 段 | 一句话 | 怎么算完 |
|---|---|---|
| **一段 · 门禁** | 先把判据立起来——CI 跑 format + analyze + test，与本地同三条 | CI 能拦下一处格式错误；三条命令本地绿 |
| **二段 · 正名** | 借家法要连命名一起借：`widgets/` → `views/`，撤掉按形状切的自造分组；越界的 4 个文件拆开 | `lib/` 里没有 `widgets/`；最大文件 < 250 行 |
| **三段 · 选型** | 路由改 `go_router`（平台契约硬要求），状态管理落成显式声明 | `main.dart` 用 `MaterialApp.router`；深链用例通过 |
| **四段 · 接通** | 结构补上 `repositories/` 与 `states/`，数据从 Provider 取，模型不再自留一份 | 界面数据全部来自 Provider；seed JSON 退出运行时 |
| **五段 · 交付形态** | 正式域名与 IaC 收口 | `data.cloud.quanttide.com` 与兼容入口同版本；`manifests/terraform/` 可 plan |
| **六段 · 多端** | 四个平台目录补齐构建验证；`integration_test/` 从空到有第一个用例 | 每平台 `flutter build` 通过；`flutter test integration_test -d linux` 有绿用例 |

## 每段跑什么

```bash
cd src/studio
dart format --set-exit-if-changed .   # 一段起
flutter analyze                        # 一段起
flutter test                           # 一段起
flutter build web                      # 四段起（接通后要能构建）
```

四段起还要能起 Provider 联调：

```bash
cd src/provider && uvicorn app.main:app --reload
```

## 现在在哪

**段零**——页面都画好了（5 Tab / 移动端适配 / 12 个测试文件，8/8 的记录是全绿，本机未装 Flutter 没复跑）。门禁、正名、路由、接通四项一件没做——功能上领先，工程上落后：**界面跑在数据模型前面**。

## 与结构无关的欠账

- 部署只刷 `data.quanttide.com`（迁移期兼容入口），正式域名 `data.cloud.quanttide.com` 未接
- CI 无 `FLUTTER_WEB_CANVASKIT_URL`（CanvasKit 未自托管）
- 四个平台目录（android 19 / ios 40 / macos 28 / windows 18 个文件）建仓起未构建验证过
- `integration_test/` 是空目录，`pubspec.yaml` 的依赖已声明；仓库根 `tests/`（pytest + xdotool）另有一套跨进程 E2E，边界要划清
- `doc/` 是页面分解产物（两页的区块、交互、数据），保留——待补一句身份说明
- 没有 IaC 目录

## 待决（不进 TODO）

- **模型从哪来**：现在 `lib/models/project.dart` 自留一份（377 行 12 个类）。契约要求「不留第二份模型」，但要先有上游——抽一个 qtdata toolkit 包发布，还是直接吃 Provider 的 JSON 契约？这决定了四段的写法。
- **包还是 Tab**：源码里的旧 ROADMAP 规划过 `qtdata-data` / `qtdata-asset` 两个独立 package，实现却把数据页、资产页做成了详情页的两个 Tab。事做了、形态变了——是认可 Tab 这个形态（删掉包的计划），还是仍要拆成包（Tab 退回壳）？
- **IaC 归属**：`src/studio/manifests/terraform/` 还是 `apps/qtdata/manifests/terraform/`（Studio 与 Site 共用一个目录？）。
