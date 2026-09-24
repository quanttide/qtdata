# studio 开发约定

约束集中一处：分层怎么叫、选型是什么、提交前跑什么。契约条款的对照体检见 [STATUS.md](./STATUS.md)，待办见 [TODO.md](./TODO.md)。

## 结构（四域 + app）

`lib/` 按**域**切成四个域，每个域内部三层（规矩与从前一致）；跨域共用的进 `app/`：

| 目录 | 装什么 |
|---|---|
| `project/` | 项目域——项目与阶段模型、项目列表页与项目 Tab、项目卡片／筛选／时间线 |
| `data/` | 数据域——数据蓝图及其界面 |
| `business/` | 商务域——报价、合同、交付、付款、流程 |
| `asset/` | 资产域——交付物（`Deliverable`）与交付矩阵（三域 × 五阶段） |
| `app/` | **跨域**共用——全局侧栏与断点、区块标题、状态徽章、阶段标签、提示与资料弹窗、详情页外壳、总览 Tab |
| `main.dart` | 装配，留在 `lib/` 根 |

每个域内的三层：

| 层 | 装什么 |
|---|---|
| `models/` | 数据模型 |
| `views/` | 界面部件（卡片、徽章、弹窗、列表、筛选条） |
| `screens/` | 页面与 Tab 壳 |

规矩：

- 界面部件那层叫 `views/`——**这是本项目约定**（Bloc 官方示例用的是 `view/` + `widgets/` 两档，我们合成一层 `views/`，因为域内界面件不分「页面级／部件级」两档）；也不按形状再切 `cards/` `common/` `dialogs/`
- 同层单文件 **≤250 行**，越界即按职责拆件，拆出来的部件进**本域**的 `views/`
- 一个文件只属于一个域；**进 `app/` 前先确认它真被两个以上域用到**（只被一个域用，就留在那个域）
- `test/` 跟着 `lib/` 同名同构（`test/{域}/{层}/`）；跨域测试基础设施留 `test/helpers/`

## 选型

| 项 | 选型 | 现状 |
|---|---|---|
| UI | Material 3 | ✓ 在用 |
| 路由 | `go_router`（平台契约要求 studio 统一用） | ✗ 未引入——现在是 `MaterialApp(home:)` 直挂 |
| 状态管理 | 平台契约把状态管理列为**项目内选型**，本仓尚未声明 | 现用 `StatefulWidget` + `setState`；改 Bloc 还是写明偏离理由，见 TODO 三段 |
| 网络／存储 | 无 | 数据来自 `assets/data/seed_projects.json` |

## 门禁（提交前跑，与 CI 同三条）

```bash
dart format --set-exit-if-changed --output=none .
flutter analyze
flutter test
```

- 本地从严、与 CI 一致：CI 钉 Flutter **3.44.9**，本机也用同一版（`$HOME/flutter/bin`）
- 静态检查是加严档（`analysis_options.yaml`：`strict-casts` / `strict-inference` / `strict-raw-types` + 三条规则）——**命中告警就改代码，不关规则**

## 依赖

- 运行时只留必要的：现在两个（`flutter`、`cupertino_icons`）
- 抽出去的东西必须发布、按版本号引，**不允许 path 依赖**
- 接外部系统先看有没有官方 SDK
- 已许可依赖清单待补（见 TODO 四段）

## 自带字体

- `fonts/` 放 Noto Sans SC **子集**四档字重（400/500/600/700，约 150KB/档），并把界面用到的 emoji 字形（💰💼📄📊📋📥）合并进同一 family；主题 `fontFamily: 'NotoSansSC'`
- 目的：文字渲染**不依赖 fonts.gstatic.com**——gstatic 打不通的机器上，布局与文字必须全部可见（屏蔽 gstatic 的 CDP 截图是验收手段）
- 维护：新增文案出现子集外的字符时，用 fontTools 重新子集化并同步四档，否则国外 CDN 不通的机器上该字符显示为空（源：google/fonts 的 `NotoSansSC[wght].ttf` + `NotoEmoji[wght].ttf`，实例化 → 按字符表子集 → 合并）
