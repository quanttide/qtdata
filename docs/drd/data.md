# 工厂产量数据 Schema

衣服工厂产量数据处理流程的领域模型与数据集定义。

## Pipeline

| 字段 | 类型 | 必填 | 默认 | 说明 |
|------|------|------|------|------|
| `id` | string | 是 | — | 唯一标识 |
| `name` | string | 是 | — | 路径风格标识，如 `factory-output-pipeline` |
| `title` | string | 是 | — | 中文标题 |
| `description` | string | 否 | `""` | 详细说明 |
| `tasks` | object[] | 是 | — | 所属任务列表 |

## Task

| 字段 | 类型 | 必填 | 默认 | 说明 |
|------|------|------|------|------|
| `id` | string | 是 | — | 唯一标识 |
| `name` | string | 是 | — | 路径风格标识，如 `import/raw-output` |
| `title` | string | 是 | — | 中文标题 |
| `description` | string | 否 | `""` | 详细说明 |
| `status` | string | 否 | `"pending"` | 任务状态 |

### TaskStatus 枚举

| 值 | 含义 |
|----|------|
| `"pending"` | 就绪 |
| `"inProgress"` | 进行中 |
| `"completed"` | 达标 |
| `"failed"` | 异常 |
| `"rejected"` | 驳回 |
| `"cancelled"` | 取消 |

## Dataset

| 字段 | 类型 | 必填 | 默认 | 说明 |
|------|------|------|------|------|
| `id` | string | 是 | — | 唯一标识 |
| `name` | string | 是 | — | 路径风格标识，如 `raw-output-data` |
| `title` | string | 是 | — | 中文标题 |
| `description` | string | 否 | `""` | 详细说明 |
| `status` | string | 否 | `"pending"` | 数据集就绪状态 |

### DatasetStatus 枚举

| 值 | 含义 |
|----|------|
| `"pending"` | 等待中 |
| `"ready"` | 已就绪 |
| `"outdated"` | 已过时 |
| `"failed"` | 异常 |

## 流程步骤与数据集映射

### 步骤说明

| 步骤 | Task | Dataset（输入→输出） | 说明 |
|------|------|----------------------|------|
| 导入 | `import/raw-output` | 外部文件 → `raw-output-data` | 导入工厂原始产量数据（Excel/CSV）：工厂名称、生产日期、衣服款式、产量数量、生产线 |
| 清洗 | `cleanse/output-data` | `raw-output-data` → `cleaned-output-data` | 修正负数产量、处理缺失值、过滤超产能异常值 |
| 合并 | `merge/output-records` | `cleaned-output-data` → `merged-output-records` | 整合 ERP 系统数据与现场记录，去重/消歧 |
| 计算 | `compute/output-kpi` | `merged-output-records` → `output-analysis-results` | 计算日产量、月产量、合格率、单位时间效率 |
| 报表 | `generate/analysis-report` | `output-analysis-results` → 报告 | 生成产量趋势、设备利用率、工人效率分析报告 |

### 数据集描述

| Dataset `name` | 预期状态 | 内容说明 |
|----------------|----------|----------|
| `raw-output-data` | `pending` | 未清洗的原始工厂产量记录 |
| `cleaned-output-data` | `ready` | 已修正异常值、清洗完成的产量数据 |
| `merged-output-records` | `ready` | 整合ERP与现场数据、去重完成的合并记录 |
| `output-analysis-results` | `ready` 或 `outdated` | 关键指标计算结果（合格率、日产量等），数据源更新后标记 `outdated` |
