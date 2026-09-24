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
| **二段 · 正名与分域** | 借家法要连命名一起借：`widgets/` → `views/`，撤掉按形状切的自造分组；越界的 4 个文件拆开；`lib/` 再按域分成 `project/ data/ business/ asset/` 四域加跨域 `app/` | `lib/` 里没有 `widgets/`；最大文件 < 250 行；`lib/` 下每个文件都落在某个域或 `app/` 里 |
| **三段 · 选型** | 路由改 `go_router`（平台契约硬要求），状态管理落成显式声明 | `main.dart` 用 `MaterialApp.router`；深链用例通过 |
| **四段 · 接通** | 结构补上 `repositories/` 与 `states/`，数据从 Provider 取，模型不再自留一份 | 界面数据全部来自 Provider；seed JSON 退出运行时 |
| **五段 · 交付形态** | 域名与 IaC 收口（入口 `studio.data.quanttide.com` 已接，旧域名 `data.quanttide.com` 去向待定） | `manifests/terraform/` 可 plan；旧域名要么改指 site 桶、要么下线 |
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

**段一（门禁）已过**——`quality-gates` 进了 CI 并首跑成功（分支与 PR 触发、`studio/*` tag 才部署），本地同版三条全绿；`analysis_options.yaml` 也加严跑绿。页面部分同样到位（5 Tab / 移动端适配 / 12 个测试文件 21 个用例）。

**段二（正名与拆分）已过**（2026-09-24）——`widgets/` → `views/`、按形状切的自造分组撤掉、4 个越界文件拆完（最长 381 → **235** 行）、约束集中进 `CONTRIBUTING.md`。复验：三条门禁绿、测试断言 105 条未削弱、`lib/` 中文字面量 71 种一一对应（行为不变）。

**同一天又把结构推进到分域**（2026-09-24）——`lib/` 重排成 `project/ data/ business/ asset/` 四域加跨域 `app/`，每域内部保持 `models/ views/ screens/`；`Deliverable` 从项目域归入资产域。复验：三条门禁绿（分域前后各一次）。

**现在站在段三（选型）的起点**：路由改 `go_router`、状态管理落成显式声明。往后的接通（各域 `repositories/` + `states/` + 吃 Provider）、交付形态、多端三段都还没动——**界面仍跑在 seed JSON 上**。

## 与结构无关的欠账

- 入口已是 `studio.data.quanttide.com`（2026-09-24 接：CDN 域名 + DNS CNAME + 单域名证书 + 私有回源 + 根改写 + TLS1.3）；`data.quanttide.com` 仍指同一个桶、两个域名都刷缓存，是过渡态——按家族惯例这个位置该是 **site 的入口**
- 平台契约正文只写了 `{产品}.cloud.quanttide.com`，**没写 studio 子域那条惯例**（家族已在用：`studio.class`、`studio.health`、`studio.agent.cloud`），待补
- CI 无 `FLUTTER_WEB_CANVASKIT_URL`（CanvasKit 未自托管）
- 四个平台目录（android 19 / ios 40 / macos 28 / windows 18 个文件）建仓起未构建验证过
- `integration_test/` 是空目录，`pubspec.yaml` 的依赖已声明；仓库根 `tests/`（pytest + xdotool）另有一套跨进程 E2E，边界要划清
- `doc/` 是页面分解产物（两页的区块、交互、数据），保留——待补一句身份说明
- 没有 IaC 目录

## 待决（不进 TODO）

- **列表页叫什么**：`lib/project/screens/dashboard_screen.dart` / `DashboardScreen` 对的是界面上的**「我的项目」页**（列表，标题就是「我的项目」）——注意别跟详情页的第一个 Tab「总览」混（那是 `lib/app/screens/overview_tab.dart`）。文件名与界面文案对不上，改法二选一，**命名归你**：跟界面走 → `projects_screen.dart` / `ProjectsScreen`；跟页面分解原型走 → `index_screen.dart` / `IndexScreen`（`doc/index.md` 用的就是这个名字）。
- **模型从哪来**：五个域的 `models/` 各自自留一份（共 6 个文件，`project/` 与 `asset/` 各 2）。契约要求「不留第二份模型」，但要先有上游——抽一个 qtdata toolkit 包发布，还是直接吃 Provider 的 JSON 契约？这决定了四段的写法。
- **包还是 Tab**：源码里的旧 ROADMAP 规划过 `qtdata-data` / `qtdata-asset` 两个独立 package，实现却把数据页、资产页做成了详情页的两个 Tab。事做了、形态变了——是认可 Tab 这个形态（删掉包的计划），还是仍要拆成包（Tab 退回壳）？
- **IaC 归属**：`src/studio/manifests/terraform/` 还是 `apps/qtdata/manifests/terraform/`（Studio 与 Site 共用一个目录？）。
