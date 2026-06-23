# ROADMAP

## 阶段一：CLI 框架 + Blueprint 命令（当前）

建立 CLI 基础骨架和第一个命令。输入 Markdown，输出 `blueprint.cue`。

- [ ] `blueprint` 子命令骨架（clap subcommand）
- [ ] 读取 Markdown → 提取数据模型和七步工作流 → 写入 `blueprint.cue`
- [ ] `blueprint show` 查看当前蓝图
- [ ] 数据目录 `data/qtdata/` 自动创建
- [ ] `workspace` 参数解析（当前默认 `price-indexer`）

## 阶段二：Scope 命令

输入 Markdown，输出 `scope.json`。

- [ ] `scope` 子命令骨架
- [ ] 读取 Markdown → 提取项目范围字段 → 写入 `scope.json`
- [ ] `scope list` 列出所有工作空间的范围书

## 阶段三：Quotation 命令

输入 Markdown，输出 `quotation.json`。

- [ ] `quotation` 子命令骨架
- [ ] 读取 Markdown → 提取工时分项和付款计划 → 写入 `quotation.json`
- [ ] `quotation show` 查看报价明细

## 阶段四：Delivery 命令

输入 Markdown 验收报告，输出交付物结构数据。

- [ ] `delivery` 子命令骨架
- [ ] 交付物清单索引 `delivery/index.json`
- [ ] 单个交付物记录 `delivery/assets/<id>.json`
- [ ] `delivery accept|reject` 验收流转

## 数据存储

```
data/qtdata/
  <workspace>/
    scope.json
    blueprint.cue
    quotation.json
    delivery/
      index.json
      assets/<id>.json
```
