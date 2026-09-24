# studio 开发约定

约束集中一处：分层怎么叫、选型是什么、提交前跑什么。契约条款的对照体检见 [STATUS.md](./STATUS.md)，待办见 [TODO.md](./TODO.md)。

## 分层（借 Bloc 家法）

`lib/` 用 Bloc 家法的公共名词分层，不自造同义词：

| 目录 | 装什么 |
|---|---|
| `screens/` | 页面外壳（装配、导航、页面级状态） |
| `screens/tabs/` | 详情页的 Tab 壳 |
| `views/` | 界面部件（卡片、徽章、弹窗、列表、筛选条） |
| `models/` | 数据模型（来源待定，见 ROADMAP「待决」） |

规矩：

- 界面那一层叫 `views/`，**不叫 `widgets/`**——家法里的公共名词是 views，改回泛称等于把公共名词换成私有名词
- **不按形状再切子目录**（以前有过 `cards/` `common/` `dialogs/`，已撤；形状既不是层也不是聚合）
- 同层单文件 **≤250 行**，越界即按职责拆件，拆出来的部件进 `views/`
- `test/` 跟着 `lib/` 同名分层（`test/views/`、`test/screens/`、`test/helpers/`）

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
