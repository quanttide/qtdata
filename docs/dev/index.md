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

验证各端模块逻辑的正确性，mock 外部依赖。

### Provider

`src/provider/test/` — 12 个测试，覆盖存储层和 API 路由。

```bash
cd src/provider && uv run pytest test/ -v
```

### Studio

`src/studio/test/` — 3 个测试，覆盖数据加载、看板渲染和错误状态。

```bash
cd src/studio && flutter test
```

---

## 联调验证

确认前后端真实互通。`tests/verify.sh` — 启动 provider → 跑 Flutter 测试（真实 HTTP）→ 清理。

```bash
cd tests && bash verify.sh
```

测试逻辑：Flutter 测试使用真实 `ApiClient()`（不 mock），连接 provider 验证 demo 数据加载和看板渲染。

```bash
# 手动分步执行同一步骤
cd src/provider && uv run uvicorn app.main:app --port 8000 &
cd src/studio && flutter test -d linux test/test_e2e.dart
```

验证点：
- Provider 返回 camelCase JSON
- Studio 加载后渲染 4 个阶段列
- 15 条任务按 type 分布正确
