# Code Review: qtdata-data

## 1. `PipelineBloc.updateTaskStatus` 强制转型不安全

`state/pipeline_bloc.dart` 第 49 行：

```dart
final current = (state as PipelineLoaded).pipeline;
```

如果 state 不是 `PipelineLoaded` 会运行时崩溃。虽然当前所有渲染路径都在 `PipelineLoaded` 下才触发此事件，但这个假设没有编译期保障。应改为：

```dart
if (state is PipelineLoaded) {
  final current = state.pipeline;
  // ...
}
```

## 2. `_PipelineView._buildFlow` 未处理空任务列表

`widgets/pipeline_screen.dart` 第 41-52 行。当 `pipeline.tasks` 为空时，for 循环不执行，只渲染一个带 `EdgeInsets.all(32)` padding 的空 Row。视觉上会留下空白区域。

建议：tasks 为空时返回 `SizedBox.shrink()` 或显示占位提示。
