# QTData Studio — 项目实现说明

## 架构层次

```
lib/  (应用壳)
  └── main.dart
       └── 依赖: qtdata_project
               │
packages/qtdata-project/  (本地功能包)
   ├── lib/src/project_board.dart
   ├── lib/src/widgets/
   │   ├── project_board_screen.dart
  │   ├── stage_column.dart
  │   └── board_column_title.dart
  └── 依赖:
       ├── quanttide_project          (领域模型: Task 等)
       └── flutter_quanttide_project  (UI 组件: BoardView, BoardColumn)
```

## lib — 应用壳

`lib/main.dart` 是唯一入口，定义 `QtDataStudio` 应用，通过 `ProjectBoardScreen` 渲染看板，并用硬编码的 16 条 demo 任务展示数据项目全生命周期。

**数据项目阶段与 type 映射：**

| 阶段 | type | 图标 |
|------|------|------|
| 需求探索 | `requirement` | `search_outlined` |
| 约定启动 | `agreement` | `description_outlined` |
| 执行监控 | `execution` | `play_arrow_outlined` |
| 验收交付 | `acceptance` | `check_circle_outlined` |

## packages/qtdata-project — 本地功能包

### 领域扩展

**`src/project_board.dart`** — 封装 `Task` 列表，按 `type` 过滤为四个阶段的只读 getter。

### UI 组件

**`src/widgets/project_board_screen.dart`** — 主看板页面，组合 `BoardView` 与四个 `StageColumn`，每列展示对应阶段的任务卡片。

**`src/widgets/stage_column.dart`** — 阶段列容器，组合 `BoardColumn` 与 `BoardColumnTitle`，通过 `cardBuilder` 回调渲染任务卡片。

**`src/widgets/board_column_title.dart`** — 列标题组件，显示图标、标题和任务计数。

**`barrel 文件 (qtdata_project.dart)`** — 统一导出 `quanttide_project` 和本地所有源文件，应用层只需 import 此文件。
