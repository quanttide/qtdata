# 前后端对接方案

## 当前状态

| 端 | 位置 | 技术栈 | 数据来源 |
|---|---|---|---|
| 服务端 | `src/provider/` | FastAPI + `fastapi-quanttide-project` v0.2.0 | 内存 dict + demo 数据 |
| 客户端 | `src/studio/` | Flutter + `qtdata-project` 包 | API 加载 |

Provider 已有 demo 数据（3 个 Project + 15 个 Task），Studio 通过 `DataBoardState` 调用 API 加载。

JSON 已统一 camelCase，Dart `Task.fromJson()` 可直接消费。

---

## 运行

```bash
# 终端 1：启动 provider
cd src/provider && uv run uvicorn app.main:app --reload --port 8000

# 终端 2：启动 studio
cd src/studio && flutter run
```

---

## 服务测试

验证 qtdata 自己的 provider 和 studio 能否互通。

### Provider

`src/provider/test/test_main.py` — 用 `TestClient` 验证完整 CRUD 链路 + camelCase 输出。

```bash
cd src/provider && uv run pytest test/ -v
```

### Studio

`src/studio/integration_test/app_test.dart` — 用 `shelf` 起 mock server，渲染看板，验证数据从网络到 UI 全链路。

```bash
cd src/studio && flutter test integration_test/
```

## 端到端测试

验证真实provider 和 studio是否可以联动。根目录tests文件夹。
