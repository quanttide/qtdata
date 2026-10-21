# 量潮数据命令行工具

CLI 以**工作空间**为顶层组织单元。每个工作空间对应一个独立项目，按 蓝图 → 范围 → 报价 → 交付 四阶段推进。

所有命令的输入是 Markdown，输出是结构化数据（JSON/CUE）。

- 工程师写 Markdown 描述需求、方案、规范
- CLI 解析 Markdown，提取结构化字段，写入契约文件
- 契约文件供版本管理、状态流转、自动化校验

## 设计依据

参见 [`docs/gallery/qtdata/`](https://github.com/quanttide/quanttide-tech/tree/main/docs/gallery/qtdata)，当前有两个工作空间：
- `price-indexer` — 价格指数计算
- `questionnare-cleaner` — 问卷/生产数据清洗

## 命令结构

```
qtdata
│
├── blueprint                   # 技术蓝图拆解
├── scope                       # 项目范围定义
├── quotation                   # 报价单
└── delivery                    # 交付与验收

```

## 开发

实现状态、待办与达成标志见 [docs/dev-guide/路线图](docs/dev-guide/roadmap.md)；代码落位与一次转换怎么走见 [docs/dev-guide/](docs/dev-guide/index.md)。README 原有四条验收标准已移入路线图，不在此重复。
