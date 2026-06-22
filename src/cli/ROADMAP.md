# 路线图 — qtdata CLI

CLI 以**工作空间**为顶层组织单元。每个工作空间对应一个独立项目，按 范围 → 蓝图 → 报价 → 交付 四阶段推进，每个阶段产出可独立存储、版本管理、状态流转的契约文件。

## 设计依据

参见 [`docs/gallery/qtdata/`](https://github.com/quanttide/quanttide-tech/tree/main/docs/gallery/qtdata)，当前有两个工作空间：
- `price-indexer` — 价格指数计算
- `questionnare-cleaner` — 问卷/生产数据清洗

## 命令结构

```
qtdata
│
├── scope                       # 项目范围定义
├── blueprint                   # 技术蓝图拆解
├── quotation                   # 报价单
└── delivery                    # 交付与验收

```

## 数据存储

所有数据以 JSON 契约文件存储在 `data/qtdata/` 下，按工作空间组织：

```
data/qtdata/
  <workspace>/
    scope.json          # 范围书
    blueprint.json       # 蓝图
    quotation.json       # 报价单
    delivery/            # 交付物清单
      index.json         # 验收清单
      assets/<id>.json  # 单个交付物记录
```

## 验收标准

- [ ] `scope` 写入 `scope.json`，字段完整可读
- [ ] `blueprint` 写入 `blueprint.cue`，含数据模型和七步工作流
- [ ] `quotation` 写入 `quotation.json`，含工时分项和付款计划
- [ ] `delivery` 验收交付物
