# 端到端测试

测试服务端、客户端、命令行工具的真实对接状况。

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
