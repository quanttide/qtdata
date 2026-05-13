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

测试相关请参考 `tests/README.md`。
