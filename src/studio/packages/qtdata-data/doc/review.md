# Code Review: qtdata-data

> 评审日期：2026-05-14。基于 refactor.md 执行后的代码。

## 已修复

| 原问题 | 修复确认 |
|--------|---------|
| 1a. `UpdateTaskStatus` 强制转型 | 已随 `UpdateTaskStatus` 删除自动消除 |
| 1b. `_buildFlow` 未处理空列表 | 已增加 `if (pipeline.tasks.isEmpty) return const SizedBox.shrink();` |
| 2a. `UpdateTaskStatus` 违反只读约束 | 已删除事件及处理函数，Bloc 回归只读 |
| 3a. `TaskStatusDisplay` 未导出 | 已补上 `export 'src/widgets/task_status_display.dart';` |
| 4a. `derivedStatus` 混合状态语义 | 已补充 `///` 注释说明降级策略 |

---

## 问题 5：Bloc 状态机不完整，缺少 loading/error 定义

`state/pipeline_bloc.dart`：

```dart
abstract class PipelineState {}

class PipelineInitial extends PipelineState {}

class PipelineLoaded extends PipelineState {
  final Pipeline pipeline;
  PipelineLoaded(this.pipeline);
}

class PipelineBloc extends Bloc<PipelineEvent, PipelineState> {
  // ...
  void _onLoadPipeline(LoadPipeline event, Emitter<PipelineState> emit) {
    emit(PipelineLoaded(event.pipeline));
  }
}
```

当前 Bloc 只有两个状态，数据流是同步的：构造参数 → `LoadPipeline` 事件 → `PipelineLoaded` → UI 渲染。Bloc 在其中充当了一个零开销的透明管道，既没有 async 边界，也没有错误路径。

如果 Bloc 是面向未来异步加载的架构约束，那么它至少应该定义 `PipelineLoading` 和 `PipelineError` 的状态形状——即使当前实现永远不会 emit 它们。

缺失这两个状态的后果：

- 未来转异步时，需要新增状态类、修改事件处理函数签名（`void` → `Future<void>`）、更新 UI 分支处理新增状态。届时改动的不仅是实现，还有状态契约。
- 当前 `_PipelineView` 用 `if (state is PipelineLoaded)` 而非 `switch`，加入新状态后不会被编译器提醒遗漏处理——新增者可能忘记处理 loading 和 error。

**本质**："先有架构"意味着先定义完整的形状再填充实现，而不是先实现最小路径等需要时再补充。状态类型就是架构契约——缺少 loading/error，当前的 Bloc 没有约束未来的实现路径，也没有为异步加载做好任何准备。如果只是为了预留位置，也应该先把状态骨架定义好，即使 handler 暂时是同步的。
