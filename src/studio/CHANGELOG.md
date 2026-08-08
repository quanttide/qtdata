# Changelog

## [studio/v0.1.0-beta.3] - 2026-08-08

### 修复
- 部署 workflow：index.html / flutter_bootstrap.js 单独 no-cache，修复入口文件一年长缓存导致的老用户更新不生效

## [studio/v0.1.0-beta.2] - 2026-08-08

### 修复
- PWA manifest 品牌化：应用名改为「量潮数据」，主题色/启动色对齐品牌（#4F46E5 / #F1F5F9）
- 部署 workflow：manifest.json 单独 no-cache，避免一年长缓存导致 PWA 元信息更新不生效

## [studio/v0.1.0-beta.1] - 2026-08-08

### 重构
- 详情页组件分解：project_detail_screen（1031 行）拆分至 lib/widgets，页面精简至 ~150 行
- widgets 按粒度分组：common/（原子组件）、cards/（卡片）、dialogs/（弹窗）
- 首页与项目卡片去重：侧边栏、状态徽章、阶段标签改用共享组件
- ItemStatus 新增三态语义色扩展，统一矩阵/时间线配色（todo 浅灰、active 品牌靛蓝）
- 资料弹窗清理旧原型 mock（TMA 商标场景文件映射、Assignor 跑数摘要）

### 新增
- 永久组件测试 16 个（test/widgets + test/screens + helpers/seed），覆盖全部组件与页面

## [studio/v0.1.0-alpha.3] - 2026-08-08

### 重构
- mock 数据迁移为 JSON seed 数据（assets/data/seed_projects.json），删除 mock_data.dart
- 数据模型新增 fromJson 解析，Project 增加 id 标识
- 首页改为异步加载 seed 数据（加载中/失败提示）

### 新增
- 资产目录 assets/data/，注册于 pubspec.yaml

## [studio/v0.1.0-alpha.2] - 2026-08-08

### 重构
- 基于多页面原型（doc/index.html + doc/project.html）重写首页与项目详情页
- 数据模型对齐原型数据结构：交付物仪表、全流程二维矩阵、数据蓝图、交付时间线

### 新增
- 首页：统计卡片（可点击筛选）、筛选按钮组、项目卡片（状态徽章/阶段标签/交付物仪表/确认收入）
- 详情页：全流程进度总览（二维网格 + 图例）、完整数据蓝图、交付时间线、资料弹窗
- 侧边栏（量 logo + 导航图标）、深色 toast 提示

### 变更
- mock 数据替换为量潮科技数字化项目（议事决议数据需求点）
- 内部定价估算：议事决议数据需求点 0.8 万元（成本法×市场法×7折）
- mock 进度更新：单周示例上线完成，批量整理进行中

## [studio/v0.1.0-alpha.1] - 2026-07-29

### 重构
- 基于最新仪表盘原型（cloud4.html）重写首页
- 删除 qtdata-project 包及所有旧依赖（bloc/provider/quanttide_data）

### 新增
- 仪表盘首页：项目进度条可视化、过滤药丸、统计计数
- 项目详情页：进度条、交付目标、完整数据蓝图、交付时间线
- `Project` 数据模型，绑定真实项目数据（客户 受让人标准化）

### 依赖变更
- 移除 `flutter_bloc`、`provider`、`quanttide_data`、`qtdata_project`
- 仅保留 Flutter SDK + `cupertino_icons`

## [studio/v0.0.4] - 2026-05-14

### 变更
- mock 数据分离为独立模块，按 DRD 更新为工厂产量场景
- PipelinePanel 和 DatasetPanel 标题风格统一（流程 / 数据集）
- PipelinePanel 移除动态 title/description，使用硬编码标题
- 修复 HomePage 缺少 key 参数的 lint 警告

## [studio/v0.0.3] - 2026-05-14

### 新增
- DatasetPanel 数据集面板
- 基于 quanttide_data 0.3.0 的 DataScreen
- BoardBloc（替代 Provider 状态管理）
- 虚线占位组件（空列提示）

### 变更
- 升级依赖 quanttide_data 0.3.0，PipelineBloc 改用 Repository 模式
- DataBoard / DataBoardState → ProjectBoard / ProjectBoardState
- 主页切换为 NavigationRail 布局（看板 + 数据 双页）

## [studio/v0.0.2] - 2026-05-14

### 新增
- 集成 provider API，从服务端动态加载数据看板
- 加载状态与错误处理：loading spinner、失败提示与重试按钮
- 基于 `flutter_quanttide_project` 的 `ProjectBoardState` 状态管理

### 变更
- 首页从硬编码演示数据改为 Provider 数据驱动
- 依赖 `provider` 状态管理库

## [studio/v0.0.1] - 2026-05-12

### 新增
- 数据服务看板原型：需求探索 → 约定启动 → 执行监控 → 验收交付 四列看板
- 基于 `flutter_quanttide_project` 的 BoardView 布局
- `qtdata-project` 包：ProjectBoard 模型 + StageColumn 通用列组件
- Flutter Linux 构建与运行脚本 `scripts/run-studio-linux.sh`
