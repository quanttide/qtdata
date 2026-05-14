# Refactor Plan: qtdata-data

按优先级排序，高优先级的改动影响正确性或架构安全，低优先级是维护性改进。

---

## P0：关闭写入后门

`state/pipeline_bloc.dart` 中的 `UpdateTaskStatus` 事件提供了修改 pipeline 状态的入口，违反 PMD 明确的只读约束。当前 UI 未调用它，但代码层面的存在本身就是风险。

**操作步骤：**

1. 删除 `UpdateTaskStatus` 事件类
2. 从 `PipelineBloc` 中删除 `_onUpdateTaskStatus` 方法及 `on<UpdateTaskStatus>(_onUpdateTaskStatus)` 注册
3. 删除 `pipeline_bloc_test.dart` 中所有与 `UpdateTaskStatus` 相关的测试用例
4. 如果将来需要写入能力，新建独立的写入 Bloc，不和只读展示混在同一层

**涉及文件：**
- `lib/src/state/pipeline_bloc.dart`
- `test/pipeline_bloc_test.dart`

---

## P1：消除强制转型

`state/pipeline_bloc.dart` 当前写法：

```dart
final current = (state as PipelineDisplayed).pipeline;
```

改为类型守卫：

```dart
if (state is PipelineDisplayed) {
  final current = state.pipeline;
  // ...
}
```

> 当前仅剩的调用方是 `_onUpdateTaskStatus`，如果 P0 已执行则该函数会被删除，此问题自动消除。P1 作为不依赖 P0 的独立防御加固。

---

## P2：处理空列表边界

`widgets/pipeline_screen.dart` 中 `_buildFlow` 未处理 `tasks` 为空的情况，渲染一个带 padding 的空 Row。

**操作步骤：**

在 `_buildFlow` 开头增加空列表守卫：

```dart
Widget _buildFlow(Pipeline pipeline) {
  if (pipeline.tasks.isEmpty) {
    return const SizedBox.shrink();
  }
  // ... 原有逻辑
}
```

如果后续有设计稿要求空状态展示占位图或提示文字，再替换为对应组件。

---

## P3：补齐公共 API

`lib/qtdata_data.dart` 缺少 `TaskStatusDisplay` extension 的导出。

**操作步骤：**

在 `lib/qtdata_data.dart` 中添加一行：

```dart
export 'src/widgets/task_status_display.dart';
```

这样外部使用者可以通过标准入口获取 `TaskStatus` 的 `.label`、`.borderColor`、`.textColor`。

---

## P4：显式化隐式语义

`lib/src/pipeline.dart` 中 `derivedStatus` 的混合状态降级策略没有记录。

**操作步骤：**

在 `derivedStatus` getter 上方或 final else 分支处添加注释：

```dart
// 混合状态（部分 completed + 部分 pending，无 failed/running）降级为 pending。
// 当前只做展示，调用方不区分"全部就绪"与"部分完成"。
// 如后续需要区分，应在 TaskStatus 中新增混合状态或在 Pipeline 上增加额外判断。
```

---

## 执行顺序

| 步骤 | 改动范围 | 涉及文件 | 建议顺序 |
|------|---------|---------|---------|
| P0 | 删除事件+处理函数+测试 | 3 文件 | 1 |
| P1 | if 守卫（如 P0 未执行） | 1 文件 | 2 |
| P2 | 空列表守卫 | 1 文件 | 3 |
| P3 | 补导出 | 1 文件 | 4 |
| P4 | 加注释 | 1 文件 | 5 |
