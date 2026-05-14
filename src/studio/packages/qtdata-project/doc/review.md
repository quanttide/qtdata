# Code Review: qtdata-project

## 1. `ProjectBoardState` 死代码

`state/project_board_state.dart` 中的 `ProjectBoardState` (ChangeNotifier) 已被 `BoardBloc` 取代，不再被导出或引用。应删除整个文件，并在 `pubspec.yaml` 中移除不再需要的 `provider` 依赖。

## 2. `BoardBloc._onLoad` 空列表分支多余

`bloc/board_bloc.dart` 第 45-49 行：

```dart
if (tasks.isEmpty) {
  emit(BoardLoaded(const ProjectBoard(tasks: [])));
} else {
  emit(BoardLoaded(ProjectBoard(tasks: tasks)));
}
```

`ProjectBoard(tasks: tasks)` 对空列表和非空列表行为一致，两个分支发的是同一个状态。改为直接 `emit(BoardLoaded(ProjectBoard(tasks: tasks)));` 即可。

## 3. `b = board!` 空断言

`widgets/project_board_screen.dart` 第 38 行：

```dart
final b = board!;
```

`BoardLoaded` 构造函数保证了 `board` 非空，模式匹配应能推导。改为 `case BoardLoaded(:final ProjectBoard board):` 用显式类型注解消除 `!`。

## 4. 文件名与模型名不一致

`bloc/board_bloc.dart` 中模型名为 `ProjectBoard`，但文件名是 `board_bloc.dart`。应与模型名一致命名为 `project_board_bloc.dart`，并在 `lib/qtdata_project.dart` 中同步更新导出路径。

## 5. `ApiClient` 缺少请求超时

`services/api_client.dart` 第 13、22 行的 HTTP 请求没有设置超时。后端挂起时请求会一直等待。应给每次调用加 `timeout`：

```dart
final resp = await _client
    .get(Uri.parse('$baseUrl/tasks'))
    .timeout(const Duration(seconds: 10));
```
