# 页面层

`tests/screens/` 封装业务页面操作，继承工具层的 `BasePage` 实现页面特化。

## HomeScreen

数据看板页面对象，提供 API 操作：

- `get_projects()` / `get_tasks()` — 获取项目/任务列表
- `create_project(name)` / `create_task(title)` — 创建项目/任务

继承自 `utils/base_page.py` 的 `BasePage`，可直接使用其窗口操作方法。
