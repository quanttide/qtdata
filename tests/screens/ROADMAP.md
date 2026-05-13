# 页面层

`tests/screens/` 封装业务页面操作，继承工具层的 `BasePage` 实现页面特化。

## ProjectScreen

项目管理页面对象，提供 API 操作：

- `get_projects()` / `get_tasks()` — 获取项目/任务列表
- `create_project(name)` / `create_task(title)` — 创建项目/任务

## DataScreen

数据处理流程页面对象：

- `get_processes()` — 获取流程列表
- `get_process_status(id)` — 获取流程状态与进度

## AssetScreen

持续交付资产页面对象：

- `get_assets()` — 获取交付物列表
- `get_asset_versions(id)` — 获取交付物版本历史
