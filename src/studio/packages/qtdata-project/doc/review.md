# Code Review: qtdata-project

## 问题 1：缺乏防御性编程与类型安全保障

### 1a. `BoardBloc._onLoad` 空列表分支多余

`bloc/board_bloc.dart`：

```dart
if (tasks.isEmpty) {
  emit(BoardLoaded(const ProjectBoard(tasks: [])));
} else {
  emit(BoardLoaded(ProjectBoard(tasks: tasks)));
}
```

两个分支 emit 的是同一个状态——`ProjectBoard(tasks: tasks)` 对空列表和非空列表的行为完全一致，`if/else` 没有实际差异。

**本质**：代码存在一个"空列表是特殊情况"的隐含假设。但空列表本身就是合法的加载结果，不需要特殊路径。这个分支暴露出对数据边界的焦虑——担心空数据会导致 UI 异常，于是加了一个看起来安全的兜底。但这个兜底没有提供任何额外保护，反而让读者困惑：空列表真的需要被特殊处理吗？两行逻辑相同的代码意味着其中一个分支是多余的，多余的代码比有问题的代码更难维护——你不知道它是冗余还是有隐式意图。

### 1b. `b = board!` 空断言

`widgets/project_board_screen.dart`：

```dart
case BoardLoaded(:final board):
    final b = board!;
```

`BoardLoaded` 的构造函数保证了 `board` 非空（`super(board: b)` 传入 `ProjectBoard` 而非 `ProjectBoard?`），但 `BoardState.board` 字段声明为 `ProjectBoard?`，分析器无法推导其非空性。`!` 的作用是让分析器闭嘴。

**本质**：类型信息在继承链中丢失了。`BoardState` 为了兼顾 `BoardInitial`、`BoardLoading`、`BoardError` 等没有 board 的状态，把 `board` 声明为可空。子类 `BoardLoaded` 虽然在语义上保证了非空，但类型系统不知道这个约定。`!` 是人为承诺"这里一定不为 null"，但如果某天有人误改了 `BoardLoaded` 构造函数的参数类型，这个承诺会在运行时静默传递 null 到下游。

---

## 问题 2：架构边界与职责不清晰

### 2a. `ProjectBoardState` 死代码

`state/project_board_state.dart` 中的 `ProjectBoardState`（ChangeNotifier）已被 `BoardBloc` 取代，但仍保留在源码中，且仍在 `lib/qtdata_project.dart` 中导出。代码库中存在两条并行的状态管理路径（Provider + Bloc），实际运行时只用了一条。

**本质**：旧路径没有被清理不是因为"暂时留着也没坏处"，而是因为迁移不完整——API 边界仍在暴露不活跃的实现，调用者不知道该用哪个。这是架构迁移未完成时的典型状态：新老路径共存，但没有明确的废弃标记或移除计划。遗留代码的毒性不亚于错误代码——它让后续开发者花时间理解为什么存在两条路径，以及该选哪条。

### 2b. `provider` 依赖残留

`pubspec.yaml` 中 `provider: ^6.1.5` 已不再被任何业务代码直接使用。遗留的依赖会增加安全更新和版本冲突的维护负担，其传递依赖也会拖累打包体积。

**与 2a 的关系**：同一个问题的两个表现——`ProjectBoardState` 的死代码是逻辑层残留，`provider` 依赖是配置层残留。

---

## 问题 3：公共 API 封装不完整

### 3a. 文件名与模型名不一致

`bloc/board_bloc.dart` 中模型名为 `ProjectBoard`，但文件名是 `board_bloc.dart`。包入口导出时也是 `export 'src/bloc/board_bloc.dart'`。

**本质**：命名不一致增加了认知负担。开发者浏览导出列表时看到 `board_bloc`，需要额外记住"这是 ProjectBoard 的 Bloc"。模块名应该是对外文档的一部分——好的命名让使用者不需要打开文件就知道里面是什么。`board_bloc` 太泛，`project_board_bloc` 才精确。

---

## 问题 4：隐式语义与文档缺失

### 4a. `ApiClient` 缺少请求超时

`services/api_client.dart` 中的 `fetchTasks` 和 `fetchProjects` 没有设置超时。当前后端是本地服务，假设网络稳定。但如果后端负载高或网络异常，请求会一直挂起，UI 层停留在 loading 状态，用户看到一个不会结束的转圈。

**本质**：没有显式声明"请求不应该等待超过 X 秒"这个约束。超时不是功能，是系统对自身可靠性的承诺——"如果 X 秒内没有响应，我不会让用户无限等待"。缺少超时等于默认承诺了"永远等待"。这个默认值在实际系统中几乎永远不是正确的。

### 4b. `_DashedBorderPainter` 的硬编码常量

`widgets/stage_column.dart` 中虚线绘制参数 `6.0`（线段长）、`10.0`（间距）是未经说明的硬编码数字。

**本质**：数值本身合理，但没有留下任何上下文说明它们的含义或约束范围。后续开发者如果需要调整虚线密度，不知道 6 和 10 是比例关系（6/16 占空比）还是绝对像素值，也不知道它们的约束范围（间距至少应该大于线宽，否则虚线会粘连）。
