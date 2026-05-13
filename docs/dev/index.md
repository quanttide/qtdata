# 前后端对接方案

## 当前状态

| 端 | 位置 | 技术栈 | 数据来源 |
|---|---|---|---|
| 服务端 | `src/provider/` | FastAPI + `fastapi-quanttide-project` v0.2.0 | 内存 dict + demo 数据 |
| 客户端 | `src/studio/` | Flutter + `qtdata-project` 包 | API 加载 |

Provider 已有 demo 数据（3 个 Project + 15 个 Task），Studio 通过 `DataBoardState` 调用 API 加载。

JSON 已统一 camelCase，Dart `Task.fromJson()` 可直接消费。

---

## 测试

### Provider 集成测试

`test_main.py` — 使用 `TestClient` 验证完整 HTTP 链路，补充断言确认 demo 数据存在且 camelCase 字段名正确。

```bash
cd src/provider && uv run pytest test/ -v
```

### Studio 集成测试

使用 Flutter `integration_test` 规范，跑在桌面/模拟器上测试完整 App Widget 树 + 网络链路。

- `integration_test/app_test.dart` — `IntegrationTestWidgetsFlutterBinding`，启动真实 HTTP server（`shelf`），渲染 `QtDataStudio`，验证数据加载和看板渲染
- `pubspec.yaml` — 新增 `integration_test`（SDK）、`shelf`（mock server）

```bash
cd src/studio && flutter test integration_test/
```

---

## 运行

```bash
# 终端 1：启动 provider
cd src/provider && uv run uvicorn app.main:app --reload --port 8000

# 终端 2：启动 studio
cd src/studio && flutter run
```
