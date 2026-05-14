# Refactor Plan: qtdata-project

按优先级排序。P0 影响正常运行，P1 影响架构整洁度，P2 影响可维护性。

---

## P0：消除运行时隐患

### P0a. 消除 `board!` 空断言

`widgets/project_board_screen.dart` 的 `case BoardLoaded(:final board)` 中通过 `board!` 强制解包。改为在模式匹配中显式注解非空类型，让类型系统而非 `!` 来保证安全。

```dart
// 改前
case BoardLoaded(:final board):
    final b = board!;

// 改后
case BoardLoaded(:final ProjectBoard board):
    // board 已是非空，无需 !
```

### P0b. 移除 `_onLoad` 空列表分支

`bloc/board_bloc.dart` 中 `if (tasks.isEmpty)` 分支与 else 分支逻辑一致，去掉多余的条件判断：

```dart
// 改前
if (tasks.isEmpty) {
  emit(BoardLoaded(const ProjectBoard(tasks: [])));
} else {
  emit(BoardLoaded(ProjectBoard(tasks: tasks)));
}

// 改后
emit(BoardLoaded(ProjectBoard(tasks: tasks)));
```

### P0c. 为 `ApiClient` 添加请求超时

`services/api_client.dart` 中 `fetchTasks` 和 `fetchProjects` 增加超时，防止后端无响应时 UI 永久 loading：

```dart
final resp = await _client
    .get(Uri.parse('$baseUrl/tasks'))
    .timeout(const Duration(seconds: 10));
```

超时时间的取值应该在配置中或至少用常量定义。10 秒是建议值，可根据实际后端响应时间调整。

---

## P1：清理死代码和遗留依赖

### P1a. 删除 `ProjectBoardState`

`state/project_board_state.dart` 已被 `BoardBloc` 完全取代。删除文件及其导出。

**操作步骤：**

1. 删除 `lib/src/state/project_board_state.dart`
2. 从 `lib/qtdata_project.dart` 中移除 `export 'src/state/project_board_state.dart';`

### P1b. 移除 `provider` 依赖

在 `pubspec.yaml` 中删除 `provider: ^6.1.5`（不再被任何业务代码使用）。

> 如果此包被外部项目引用且外部项目仍在使用 `provider`，应先在 `CHANGELOG` 中标记废弃并于下次大版本切除。

### P1c. 清理无用 import

`lib/src/state/project_board_state.dart` 和 `lib/src/project_board.dart`（如未删除）中存在 `import 'package:quanttide_project/quanttide_project.dart';`，这是一个导入自身的无用语句。如果 P1a 已执行则 `project_board_state.dart` 已删除，只需检查 `project_board.dart`。

---

## P2：命名对齐

### P2a. 文件名与模型名一致

`bloc/board_bloc.dart` 改为 `bloc/project_board_bloc.dart`，同步更新导出：

```dart
// lib/qtdata_project.dart
// 改前
export 'src/bloc/board_bloc.dart';
// 改后
export 'src/bloc/project_board_bloc.dart';
```

涉及引用更新：
- `widgets/project_board_screen.dart` 中的 `import '../bloc/board_bloc.dart'`
- 测试文件中的对应 import

---

## P3：显式化隐式语义

### P3a. 虚线参数常量化

`widgets/stage_column.dart` 中 `_DashedBorderPainter` 的 `6.0` / `10.0` 提取为具名常量并注释含义：

```dart
class _DashedBorderPainter extends CustomPainter {
  // 虚线线段长度（像素）
  static const double _dashLength = 6.0;
  // 虚线间隔长度（像素），需大于线宽（1px）避免粘连
  static const double _dashGap = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    // ...
    while (distance < metric.length) {
      final end = (distance + _dashLength).clamp(0.0, metric.length);
      canvas.drawPath(metric.extractPath(distance, end), paint);
      distance += _dashLength + _dashGap;
    }
  }
}
```

---

## 执行顺序

| 步骤 | 改动范围 | 涉及文件 | 建议顺序 |
|------|---------|---------|---------|
| P0a | 类型注解 | `project_board_screen.dart` | 1 |
| P0b | 移除多余分支 | `board_bloc.dart` | 2 |
| P0c | 超时 | `api_client.dart` | 3 |
| P1a | 删除死代码 | `project_board_state.dart`、`qtdata_project.dart` | 4 |
| P1b | 移除依赖 | `pubspec.yaml` | 5 |
| P1c | 清理 import | `project_board.dart` | 6 |
| P2a | 命名对齐 | 多个文件 | 7 |
| P3a | 常量化 | `stage_column.dart` | 8 |
