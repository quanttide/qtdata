# 前后端对接方案

## 当前状态

| 端 | 位置 | 技术栈 | 数据来源 |
|---|---|---|---|
| 服务端 | `src/provider/` | FastAPI + `fastapi-quanttide-project` v0.2.0 | 无存储，仅 API |
| 客户端 | `src/studio/` | Flutter + `qtdata-project` 包 | 硬编码 demo 数据 |

Provider 只有 API 层（`build_default()` 用内存 dict），无数据则接口返回空列表。

JSON 已统一 camelCase，Dart `Task.fromJson()` 可直接消费。

---

## 开发

### 1. Provider 存储层

替换 `build_default()` 为自定义 `build()` + 有数据的内存存储（后续可换持久化）：

- `app/storage.py` — 内存 dict + 预置 demo Project 和 Task
- `app/main.py` — 注册自定义路由

Demo 数据与 Studio 当前硬编码数据对齐，确保前端开箱即有数据显示。

### 2. Studio 数据层

在 `packages/qtdata-project` 中新增：

- `lib/src/services/api_client.dart` — HTTP 调用 provider，返回 `List<Task>`
- `lib/src/state/data_board_state.dart` — `ChangeNotifier`，管理 `DataBoard` 的加载/刷新/错误状态

新增依赖：`http` 或 `dio`（`qtdata-project/pubspec.yaml`）。

### 3. 替换入口

`lib/main.dart` 中 `_demoBoard()` 替换为 `DataBoardState`：

```dart
ChangeNotifierProvider(
  create: (_) => DataBoardState()..load(),
  child: Consumer<DataBoardState>(
    builder: (ctx, state, _) => DataBoardScreen(board: state.board),
  ),
)
```

---

## 测试

### Provider 存储层

```bash
cd src/provider && uv run pytest test/ -v
```

新增 `test_storage.py` — 验证 demo 数据加载、CRUD 操作。

### Studio 数据层

`packages/qtdata-project/test/` 新增：

- `test_api_client.dart` — mock HTTP，验证 JSON 解析和错误处理
- `test_data_board_state.dart` — 验证加载/刷新/空数据状态

---

## 运行

```bash
# 终端 1：启动 provider
cd src/provider && uv run uvicorn app.main:app --reload --port 8000

# 终端 2：启动 studio
cd src/studio && flutter run
```
