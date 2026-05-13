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

`src/studio/test/test_service.dart` — mock HTTP，验证数据加载、看板渲染和错误状态。

```bash
cd src/studio && flutter test
```

---

## 端到端测试：平台差异与覆盖策略

端到端的问题在于 Flutter Web 使用 `dart:html` HTTP 实现，与 `dart:io` 不互通，无法用同一套测试覆盖所有目标平台。

### 只测桌面即可

| 理由 | 说明 |
|------|------|
| 契约已由 SDK 保证 | JSON 序列化在主仓库测试，qtdata 不重复验证 |
| 桥接逻辑极其薄 | `ApiClient` 只做 HTTP 调用 + JSON 反序列化，不含平台相关业务 |
| 桌面覆盖 `dart:io` | Linux/macOS/Windows 共用 `dart:io`，测一个即覆盖全部 |
| CI 可运行 | 桌面端无需模拟器，不增加 CI 复杂度 |

### 运行方式

```bash
# 终端 1：启动 provider（带真实存储）
cd src/provider && uv run uvicorn app.main:app --port 8000

# 终端 2：运行测试（Linux 桌面）
cd src/studio && flutter test -d linux test/
```

Web 端如有需要，在本地单独验证。
