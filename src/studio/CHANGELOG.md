# Changelog

## [studio/v0.0.2] - 2026-05-14

### 新增
- 集成 provider API，从服务端动态加载数据看板
- 加载状态与错误处理：loading spinner、失败提示与重试按钮
- 基于 `flutter_quanttide_project` 的 `DataBoardState` 状态管理

### 变更
- 首页从硬编码演示数据改为 Provider 数据驱动
- 依赖 `provider` 状态管理库

## [studio/v0.0.1] - 2026-05-12

### 新增
- 数据服务看板原型：需求探索 → 约定启动 → 执行监控 → 验收交付 四列看板
- 基于 `flutter_quanttide_project` 的 BoardView 布局
- `qtdata-project` 包：DataBoard 模型 + StageColumn 通用列组件
- Flutter Linux 构建与运行脚本 `scripts/run-studio-linux.sh`
