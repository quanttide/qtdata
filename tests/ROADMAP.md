# E2E 测试实现路线

## P1 基础设施

- `conftest.py`：session-scope fixture（provider 启停、Flutter driver 初始化）
- `utils/`：截图辅助、录制开关

## P2 操作层

- `screens/`：按业务屏幕实现 Page Object（登录、数据浏览、看板等）

## P3 场景层

- `scenarios/`：首个 E2E 用例并跑通


