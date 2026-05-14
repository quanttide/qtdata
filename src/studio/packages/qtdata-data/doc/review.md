# Code Review: qtdata-data

> 评审日期：2026-05-14。第二轮。

## 架构变更说明

本次评审前代码经历了结构性重构：

- 模型（`Pipeline`、`Task`、`TaskStatus`）移至外部 `quanttide_data` 包，本地不再维护
- `TaskStatus` 从 4 态扩展为 6 态：`pending`、`inProgress`、`completed`、`failed`、`rejected`、`cancelled`
- `task_status_display.dart` 删除，label/color 逻辑移至外部包
- `Task` 新增 `title` 字段（显示名），`order` 字段移除

---

## 已修复（上一轮）

| 原问题 | 状态 |
|--------|------|
| 1a. 强制转型 | 随 `UpdateTaskStatus` 删除自动消除 |
| 1b. `_buildFlow` 空列表 | 已增加 `if (tasks.isEmpty) return SizedBox.shrink()` |
| 2a. `UpdateTaskStatus` 只读违规 | 已删除 |
| 3a. `TaskStatusDisplay` 未导出 | 已随文件删除自动解决（功能移至外部包） |
| 4a. `derivedStatus` 混合语义 | 已补充注释 |

---

## 仍存在的问题

### 问题 5（未修复）：Bloc 状态机不完整

上一轮已详细分析。`PipelineBloc` 仍只有 `PipelineInitial` 和 `PipelineLoaded` 两个状态，缺少 loading/error 骨架。作为面向异步的架构约束，状态定义本身就是契约——当前的实现没有为未来做好任何准备。

---

## 新发现的问题

### 问题 6：`Color(task.status.color)` 缺少 alpha 保障

`widgets/task_card.dart`：

```dart
final color = Color(task.status.color);
```

`Color(int)` 将整数的前 8 位解析为 alpha 通道。如果外部 `quanttide_data` 的 `TaskStatus.color` 返回的是无 alpha 的 RGB 值（如 `0x16A34A` 而非 `0xFF16A34A`），颜色会完全透明，卡片边框和状态标签不可见。

当前代码假设外部包返回的值一定包含 alpha 通道（`0xFF......`），但这个假设没有文档化，也没有在消费侧做防御。

**本质**：跨包边界的值契约没有显式化。`Color(int)` 是 Flutter 底层 API 中出了名的陷阱——同样的整数在不同上下文中含义不同（ARGB vs RGB）。消费者依赖上游包"恰好返回了正确格式"的隐式约定，而不是通过命名工厂（如 `Color.fromARGB`）明确意图。

建议：
1. 在 `TaskCard` 中使用 `Color.fromARGB(255, ...)` 或 `Color.fromRGBO` 显式构造，不依赖外部包的整数格式
2. 或者确认 `quanttide_data` 的 `color` 返回值格式并在依赖文档中记录

### 问题 7：`color` 变量名过于宽泛

```dart
final color = Color(task.status.color);
```

在 Widget build 方法中，`color` 是 Flutter 中的高频名称（`Colors.xxx`、`Theme.of(context).colorScheme` 等）。局部变量覆盖了这些引用且不表达语义——`statusColor` 或 `taskStatusColor` 更清晰。

### 问题 8：`quanttide_data` 外部依赖未说明

`pubspec.yaml` 中声明了 `quanttide_data: ^0.1.0`，但包内没有任何文档说明：
- 这个包提供了什么（模型定义、状态枚举）
- 版本兼容要求
- 本地开发和测试时如何获取这个依赖

当前测试可以运行可能因为它已被其他路径解析，但对新加入的开发者来说，缺少这个上下文会导致配置环境时卡住。

建议：在 `README.md` 或包级 doc comment 中说明外部依赖关系。
