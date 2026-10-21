# 路线图

端根的 `ROADMAP.md` 已并入本文并删除（2026-10-21）。README 里原有的四条「验收标准」一并移入本文，避免同一件事两处维护。

## 现状

四个子命令的骨架与 Markdown 转换已实现（`src/main.rs`，46 行）：`blueprint` / `scope` / `quotation` / `delivery` 各为 clap 子命令，经 LLM 转成目标格式，写入 `--output` 指定的文件。

与原设想的两处差距：输出路径由调用方显式给出，未落 `data/qtdata/<workspace>/` 结构；`workspace` 参数与默认值尚不存在。

## 待办

### 阶段一：Blueprint

- [ ] `blueprint show` 查看当前蓝图
- [ ] 数据目录 `data/qtdata/` 自动创建
- [ ] `workspace` 参数解析（当前无此参数，输出路径全由 `--output` 指定）

### 阶段二：Scope

- [ ] `scope list` 列出所有工作空间的范围书

### 阶段三：Quotation

- [ ] `quotation show` 查看报价明细

### 阶段四：Delivery

- [ ] 交付物清单索引 `delivery/index.json`
- [ ] 单个交付物记录 `delivery/assets/<id>.json`
- [ ] `delivery accept|reject` 验收流转

## 目标数据结构（未实现）

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

## 达成标志

- 四个命令在不传 `--output` 时按上述结构落盘；
- `blueprint show` / `scope list` / `quotation show` 能从该结构读回；
- `scope.json` 字段完整可读；`blueprint.cue` 含数据模型与七步工作流；`quotation.json` 含工时分项与付款计划——三条须给出样例文件作为证据，不接受「提示词已要求」；
- `delivery accept|reject` 能改交付物状态并留记录。
