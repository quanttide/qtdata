# ROADMAP

先独立研发再看模样，逐步对接。

## 1. Provider 完成

- [x] FastAPI 服务骨架
- [x] Project/Task CRUD 路由
- [x] camelCase JSON API（`fastapi-quanttide-project` v0.2.0）
- [ ] 存储层（内存 dict + demo 数据）
- [ ] 存储层测试

## 2. Studio 接入 API

- [ ] `qtdata-project` 数据层（api_client + state）
- [ ] 替换硬编码 demo 数据
- [ ] 数据层测试

## 3. 联调

- [ ] Provider 启动 → Studio 加载显示数据
- [ ] CRUD 操作端到端验证

数据问题在开发过程中解决，用数据方法解决数据问题。
