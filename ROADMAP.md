# ROADMAP

先独立研发再看模样，逐步对接。

## 1. Provider 完成

- [x] FastAPI 服务骨架
- [x] Project/Task CRUD 路由
- [x] camelCase JSON API（`fastapi-quanttide-project` v0.2.0）
- [x] 存储层（内存 dict + demo 数据）
- [x] 存储层单元测试

## 2. Studio 接入 API

- [x] `qtdata-project` 数据层（api_client + state）
- [x] 替换硬编码 demo 数据
- [x] 数据层单元测试

## 3. 服务测试

- [x] Provider 端（TestClient 验证完整 CRUD + camelCase）
- [x] Studio 端（mock HTTP 验证数据加载和错误状态）

## 4. 端到端测试

- [ ] Provider 接入真实数据库（替代内存 dict）
- [ ] 启动真实服务 + 真实 APP，验证数据持久化和前后端互通

数据问题在开发过程中解决，用数据方法解决数据问题。
