# Implementation Plan

## 概念定义

```
Pipeline
  └── Task
        └── output/input: Dataset
                         ├── schema: Schema (引用，纯结构契约)
                         └── status: TaskStatus (数据就绪状态)
```

| 概念 | 职责 | 是否有状态 |
|------|------|-----------|
| `Schema` | 结构契约，Contract/Catalog 的一部分 | 否 |
| `Dataset` | 数据产物，引用 Schema 作为结构定义 | 是 |
| `Task` | 执行单元，消费/产出 Dataset | — |

Task 关联两个 Dataset 列表：`inputDatasets`（上游依赖）和 `outputDatasets`（本步骤产物）。

## Architecture

```
DataScreen
├── BlocProvider
│   └── PipelineView (horizontal flow with TaskCards)
└── DatasetSection (datasets grid)
```

DataScreen 提供页面框架和 `BlocProvider`，内部包含 PipelineView 和 DatasetSection 两个平级区域。

## 组件划分

| 文件 | 组件 | 职责 |
|------|------|------|
| `data_screen.dart` | `DataScreen` | 页面容器，构建 BlocProvider，布局上下两区 |
| `pipeline_view.dart` | `PipelineView` | 横向流程流，已有 |
| `task_card.dart` | `TaskCard` | 单步卡片，已有 |
| `dataset_card.dart` | `DatasetCard` | Dataset 卡片，新建 |
| `dataset_section.dart` | `DatasetSection` | Dataset 列表区域，新建 |

## 数据流

```
                            ┌─────────────────┐
                            │  LoadPipeline    │
                            │  LoadDatasets    │
                            └────────┬────────┘
                                     │
                            ┌────────▼────────┐
                            │   DataBloc      │
                            │  ┌────────────┐ │
                            │  │ pipeline   │ │
                            │  │ datasets   │ │
                            │  └────────────┘ │
                            └────────┬────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
            ┌───────▼───────┐ ┌──────▼───────┐ ┌──────▼───────┐
            │ PipelineView  │ │DatasetSection│ │ ...          │
            └───────────────┘ └──────────────┘ └──────────────┘
```

当前 PipelineBloc 只管理 pipeline 状态。后续需要扩展或新增 DataBloc 同时管理 pipeline 和 datasets 的加载。

## 布局方案

```
┌────────────────────────────────────────────┐
│  ← 数据                                    │  AppBar
├────────────────────────────────────────────┤
│                                            │
│  [导入] → [清洗] → [合并] → [计算] → [生成]  │  PipelineView
│  达标     达标     进行中    进行中    就绪   │  (水平滚动)
│                                            │
├────────────────────────────────────────────┤
│  数据集                                     │  DatasetSection
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐   │  (网格/列表)
│  │dataset│ │dataset│ │dataset│ │dataset│   │
│  │ 达标  │  │ 就绪  │  │进行中 │  │进行中 │   │
│  └──────┘  └──────┘  └──────┘  └──────┘   │
│                                            │
└────────────────────────────────────────────┘
```

PipelineView 水平滚动展示流程，DatasetSection 在下方以网格或列表展示数据集及其状态。

DatasetSection 展示整个 Pipeline 相关的所有 Dataset（从所有 Task 的 input/output 聚合去重），每个 Dataset 卡显示 name、title、status，关联的 schema 名。

## 步骤

1. 在 quanttide_data 中定义 `Dataset` 实体（纯 Dart，schema 引用 + status）
2. Task 增加 `inputDatasets` / `outputDatasets` 字段
3. 创建 `DatasetCard` widget
4. 创建 `DatasetSection` widget
5. 更新 `DataScreen` 集成 PipelineView + DatasetSection
6. 扩展 Bloc 管理 datasets 数据
