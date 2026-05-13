# Provider ROADMAP

## 数据处理流程 API

对应 Studio `qtdata-process` package，提供数据处理流程的后端支持。

- [ ] 数据流程模型：Process（数据源、处理步骤、依赖关系、状态）
- [ ] 流程 CRUD 路由：processes 资源 endpoints
- [ ] 流程状态流转与进度追踪

## 资产管理 API

对应 Studio `qtdata-asset` package，提供持续交付资产的后端支持。

- [ ] 资产模型：Asset（交付物类型、版本、状态、关联流程）
- [ ] 资产 CRUD 路由：assets 资源 endpoints
- [ ] 版本管理与状态追踪

## 基础

- [ ] 接入持久化数据库（替代当前内存 dict）
- [ ] API 文档补充（新路由的 OpenAPI 描述）
