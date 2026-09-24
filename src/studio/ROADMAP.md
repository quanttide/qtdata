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
cd src/provider && go run ./cmd/server
```

## 现在在哪

**段一（门禁）已过**——`quality-gates` 进了 CI 并首跑成功（分支与 PR 触发、`studio/*` tag 才部署），本地同版三条全绿；`analysis_options.yaml` 也加严跑绿。页面部分同样到位（5 Tab / 移动端适配 / 12 个测试文件 21 个用例）。

**段二（正名与拆分）已过**（2026-09-24）——`widgets/` → `views/`、按形状切的自造分组撤掉、4 个越界文件拆完（最长 381 → **235** 行）、约束集中进 `CONTRIBUTING.md`。复验：三条门禁绿、测试断言 105 条未削弱、`lib/` 中文字面量 71 种一一对应（行为不变）。

**同一天又把结构推进到分域**（2026-09-24）——`lib/` 重排成 `project/ data/ business/ asset/` 四域加跨域 `app/`，每域内部保持 `models/ views/ screens/`；`Deliverable` 从项目域归入资产域。复验：三条门禁绿（分域前后各一次）。

**段三（选型）已过**（2026-09-24）：`go_router` ^18 + `MaterialApp.router`，路由表 `/`（列表）+ `/projects/:id?tab=<slug>`（深链直达 Tab，点 Tab 同步 URL），深链/未知 id 用例 5 个（`test/app/router_test.dart`）；状态管理显式声明——**0.1.0 继续 `setState`**，偏离 Bloc 的理由成文（CONTRIBUTING 选型段）。同日连带：详情页头部拆件守住单文件 ≤250、`integration_test/` 首用例真跑 Linux 绿（启动→看板→详情→切 Tab）、支持矩阵写进 README（**0.1.0 只承诺 Web + Linux**）、字体字符门禁进 CI。

**段四（接通）拍板**（2026-09-24，正式版口径）：0.1.0 以**展示件**形态发布——数据仍跑 seed JSON、商务数字为示例值（`pricingNote` 注明），不接 Provider；`repositories/` + `states/` + 模型归属（待决第二条）在段四做，做完发接通版。段五余 IaC 与域名去向，段六余四平台构建验证（0.1.0 不支持，见 README 支持矩阵）。

## 与结构无关的欠账

- 入口已是 `studio.data.quanttide.com`（2026-09-24 接：CDN 域名 + DNS CNAME + 单域名证书 + 私有回源 + 根改写 + TLS1.3）；`data.quanttide.com` 仍指同一个桶、两个域名都刷缓存，是过渡态——**已定案（2026-09-24）：`src/site` 部署线建立前维持过渡态（两域名同桶、同刷新），site 上线时再改指 site 桶**
- 平台契约正文只写了 `{产品}.cloud.quanttide.com`，**没写 studio 子域那条惯例**（家族已在用：`studio.class`、`studio.health`、`studio.agent.cloud`），待补
- ~~CI 无 `FLUTTER_WEB_CANVASKIT_URL`（CanvasKit 未自托管）~~ **已清**（2026-09-24，rc.2）：构建改 `--no-web-resources-cdn` 自托管仓内 `canvaskit/`，原环境变量方案作废；验收 `scripts/check-web-gstatic-blocked.mjs`
- 四个平台目录（android 19 / ios 40 / macos 28 / windows 18 个文件）建仓起未构建验证过——**0.1.0 支持矩阵只含 Web + Linux**（已写进 README），四平台验证留六段
- ~~`integration_test/` 是空目录~~ **已清**（2026-09-24）：首用例 `app_flow_test.dart` `-d linux` 真跑绿；两套测试边界写明（`tests/README.md` + `integration_test/README.md`）
- `doc/` 是页面分解产物（两页的区块、交互、数据），保留——身份说明已补（`doc/index.md` 开头）
- 没有 IaC 目录（段五）

## 待决（不进 TODO）

- **列表页命名——已决（2026-09-24）**：0.1.0 保持 `dashboard_screen.dart` / `DashboardScreen` 不改名（改名无行为收益、测试引用面大）；是否跟界面文案改 `projects_screen` 并入段四接通时一并处理。
- **模型从哪来**：五个域的 `models/` 各自自留一份（共 6 个文件，`project/` 与 `asset/` 各 2）。契约要求「不留第二份模型」，但要先有上游——抽一个 qtdata toolkit 包发布，还是直接吃 Provider 的 JSON 契约？这决定了四段的写法。
- **包还是 Tab**：源码里的旧 ROADMAP 规划过 `qtdata-data` / `qtdata-asset` 两个独立 package，实现却把数据页、资产页做成了详情页的两个 Tab。事做了、形态变了——是认可 Tab 这个形态（删掉包的计划），还是仍要拆成包（Tab 退回壳）？
- **IaC 归属——已决（2026-09-24）**：`src/studio/manifests/terraform/`（studio 先落；site 部署线建立后自建自己的，不共用目录）。
