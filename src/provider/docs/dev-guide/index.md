# 开发指南

服务怎么继续长。怎么用看[使用指南](../user-guide/index.md)，字段与错误码看[接口参考](../api-references/index.md)。

## 目录落位

```text
src/provider/
├── cmd/server/main.go        装配：config → store → mux → 路由注册 → 日志 → 优雅关闭
├── internal/
│   ├── api/
│   │   ├── handler.go        健康检查
│   │   ├── resource.go       三资源共用的泛型 resource[T]（list / get / create / update / delete）
│   │   ├── dataset.go        数据集：集合名、校验、时间维护、路由注册
│   │   ├── project.go        项目：同上
│   │   ├── task.go           任务：同上
│   │   └── response.go       WriteJSON / WriteError 与错误响应体
│   ├── model/                资源模型（project.go / task.go / qtdata_dataset.go）
│   ├── store/store.go        Store 接口、Config、按 driver 分派
│   ├── store/filestore.go    file 驱动：一集合一 JSON 文件
│   ├── config/config.go      配置加载：默认值 → JSON 文件 → 环境变量
│   └── version/version.go    版本号
├── docs/
│   ├── user-guide/           怎么跑、怎么调
│   ├── api-references/       路由、字段、错误码
│   └── dev-guide/            本文与路线图
├── go.mod
└── CHANGELOG.md
```

## 一次请求怎么走

`POST /api/v1/qtdata/tasks` 为例：

1. `main.go` 里 `api.RegisterTaskRoutes(mux, st)` 把五个路由挂到 mux；
2. 命中 `resource[*model.Task].create`；
3. `newItem` 造空对象，`json.NewDecoder` 反序列化请求体（失败即 `INVALID_INPUT`）；
4. `validate` 判必填（失败即 `VALIDATION_ERROR`）；
5. `onCreate` 写 `createdAt` / `updatedAt`；
6. `store.Create` 分配 id 并落盘 `qtdata/tasks.json`；
7. `WriteJSON(…, 201)`。

## 加一个资源

三步：

1. `internal/model/<x>.go` 定字段，实现 `GetID` / `SetID`；
2. `internal/api/<x>.go` 用 `resource[T]` 装配——集合名、`validate`、`onCreate` / `onUpdate`，再写 `RegisterXxxRoutes`；
3. `cmd/server/main.go` 的「领域路由注册点」添一行。

服务端维护的字段放 `onCreate` / `onUpdate`，不要指望客户端传。

## 存储

`Store` 接口六个方法（`List` / `Get` / `Create` / `Update` / `Delete` / `Close`），按集合名整取整存。file 驱动把集合名映射成文件路径：集合 `qtdata/tasks` → `<QTDATA_STORE_PATH>/qtdata/tasks.json`，文件内是 `id → 原始 JSON` 的映射，`List` 按 id 排序。`store.New` 只实现了 `file` 分支，选 `s3` 会返回 `s3 driver not yet implemented`；`store.Config` 已预留 `driver` 字段。

## 服务边界

本服务只做资源存取，做三件事的持久化：数据集、项目、任务。

数据处理的流程语义不在这里。`data/roadmap/qtcloud-data/spec.md` 把流程分两层——`blueprint.steps`（流程规格，设计态）与 `pipeline.states`（可执行状态机，实现态）——两层都在 CLI 侧：`src/cli/src/stage/design.rs`、`stage/implement.rs` 生成与投影，`stage/process.rs` 消费 `pipeline.states` 在本地跑状态机。所以"流程状态流转与进度追踪"由 CLI 的 `process` 命令承担，不是本服务的端点。

资产（Asset：交付物类型、版本、状态、关联流程）本服务既没有模型也没有路由，只有旧路线图里的一句设想。

结论：不要在本服务顺手加 `processes` / `assets` 端点。真要加，前提是先决定流程运行态或资产台账要服务端化——那是一次领域变更，不是补一个 handler。

## 已知问题

- `PUT` 是整体替换，请求体不带 `createdAt` 就会被清空（`onUpdate` 只刷新 `updatedAt`）。使用侧见[接口参考](../api-references/index.md)·更新是整体替换。
- 没有 OpenAPI 描述文件，接口参考是手写的，改路由时要同步改文档。
- S3 驱动只有分派分支，没有实现。

## 继续做什么

见[路线图](roadmap.md)。
