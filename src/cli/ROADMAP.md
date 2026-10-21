# ROADMAP

现状订正（2026-10-21）：四个子命令的骨架与 Markdown 转换已实现于 `src/main.rs`（46 行；`Blueprint` / `Scope` / `Quotation` / `Delivery` 四个 clap 子命令，经 LLM 转成目标格式后写入指定文件）。与原设想有两处差距：输出路径由 `--output` 显式给出，未落 `data/qtdata/<workspace>/` 结构；`workspace` 参数与默认值尚不存在。

## 阶段一：CLI 框架 + Blueprint 命令（当前）

- [x] `blueprint` 子命令骨架（clap subcommand）
- [x] 读取 Markdown → 经 LLM 转成 CUE → 写出文件（提示词不专门要求"七步工作流"结构，产出形状未校验）
- [ ] `blueprint show` 查看当前蓝图
- [ ] 数据目录 `data/qtdata/` 自动创建
- [ ] `workspace` 参数解析（当前无此参数，输出路径全由 `--output` 指定）

## 阶段二：Scope 命令

- [x] `scope` 子命令骨架
- [x] 读取 Markdown → 提取项目范围字段 → 写出 JSON
- [ ] `scope list` 列出所有工作空间的范围书

## 阶段三：Quotation 命令

- [x] `quotation` 子命令骨架
- [x] 读取 Markdown → 提取工时分项和付款计划 → 写出 JSON
- [ ] `quotation show` 查看报价明细

## 阶段四：Delivery 命令

- [x] `delivery` 子命令骨架
- [ ] 交付物清单索引 `delivery/index.json`
- [ ] 单个交付物记录 `delivery/assets/<id>.json`
- [ ] `delivery accept|reject` 验收流转

## 数据存储（目标结构，未实现）

当前每个命令只写调用方指定的单个文件，下列结构尚未落地：

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

达成标志：四个命令在不传 `--output` 时按上述结构落盘，`blueprint show` / `scope list` / `quotation show` 能从中读回。
