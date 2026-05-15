# ROADMAP

## 数据页面

主要目标：增加数据页面，展示数据处理流程。

- [x] Provider 数据处理流程 CRUD API（Project/Task 已实现）
- [x] 数据页面 UI（框架已搭建，依赖 quanttide_data 包）
- [ ] 数据处理流程建模：定义数据源、处理步骤、依赖关系
- [ ] Studio 数据页面接入 API，动态加载流程数据
- [ ] E2E 测试覆盖数据页面交互场景

## 资产页面

主要目标：增加资产页面，用于持续交付场景。

- [ ] 资产模型建模：定义交付物类型、版本、状态
- [ ] 资产页面 UI：交付物列表、状态追踪、版本管理
- [ ] Provider 资产 CRUD API
- [ ] Studio 资产页面接入 API
- [ ] E2E 测试覆盖资产页面交互场景

## 测试基础设施（已完成）

- [x] conftest.py：provider + Flutter app 启停
- [x] utils/：BasePage, screenshot, recorder
