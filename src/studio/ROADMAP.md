# Studio ROADMAP

## 新增 packages

- [ ] `qtdata-process`：数据处理流程组件包（流程定义、阶段展示、状态追踪）
- [ ] `qtdata-asset`：持续交付资产管理组件包（交付物模型、版本管理、状态追踪）

## 主程序改造

- [ ] 页面路由：增加数据页面、资产页面，支持页面间导航
- [ ] 集成 `qtdata-process`：数据页面展示数据处理流程
- [ ] 集成 `qtdata-asset`：资产页面展示交付物列表与状态
- [ ] 根据路由拆分 `main.dart`，避免单一文件膨胀
