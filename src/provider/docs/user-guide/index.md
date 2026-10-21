# 数据服务使用指南

量潮数据的 Go 服务端：把数据集、项目、任务三类资源存下来，供 CLI 与前端读写。它自己不做数据处理——流程编排跑在 CLI 的 `process` 命令里（见[开发指南](../dev-guide/index.md)·服务边界）。

本指南讲怎么把它跑起来、怎么调用。字段与错误码看[接口参考](../api-references/index.md)，程序怎么继续长看[开发指南](../dev-guide/index.md)。

## 跑起来

```bash
cd src/provider
go run ./cmd/server            # 默认监听 :8000
```

出二进制：

```bash
go build -o qtdata-provider ./cmd/server
./qtdata-provider
```

启动时的日志是两行 `config loaded` 与 `store initialized`，之后每来一次请求打一对 request / response：

```text
time=... level=INFO msg="config loaded" addr=:8000 store={...}
time=... level=INFO msg="store initialized" driver=file path=data
time=... level=INFO msg="listening" addr=:8000
```

## 走一遍

先探活：

```bash
curl -s http://127.0.0.1:8000/health
```

```json
{"status":"ok"}
```

建一个数据集（`name` 必填，缺了返回 400）：

```bash
curl -s -X POST http://127.0.0.1:8000/api/v1/qtdata/datasets \
  -d '{"name":"课程档案","description":"实训基地课程档案数据集","version":"v0.1.0","status":"draft"}'
```

```json
{"id":"67f93079f42d829a96bdc1e82c1a5bc9","name":"课程档案","description":"实训基地课程档案数据集","version":"v0.1.0","status":"draft","created_at":"2026-10-21T04:06:48Z"}
```

再列出来（返回数组）：

```bash
curl -s http://127.0.0.1:8000/api/v1/qtdata/datasets
```

```json
[{"id":"67f93079f42d829a96bdc1e82c1a5bc9","name":"课程档案","description":"实训基地课程档案数据集","version":"v0.1.0","status":"draft","created_at":"2026-10-21T04:06:48Z"}]
```

存到哪了：`data/qtdata/<资源>.json`，一个资源一个文件，按 id 归档。

```text
data/qtdata/datasets.json
data/qtdata/projects.json
data/qtdata/tasks.json
```

## 配置

优先级：环境变量 > `CONFIG_PATH` 指向的 JSON 文件 > 默认值。环境变量认 `QTDATA_` 前缀，无前缀的旧名（`ADDR`、`STORE_DRIVER`、`STORE_PATH`、`LOG_LEVEL`、`LOG_FORMAT`）仍可用，前缀优先。

| 变量 | 默认值 | 说明 |
|:-----|:-------|:-----|
| `QTDATA_ADDR` | `:8000` | 监听地址 |
| `QTDATA_STORE_DRIVER` | `file` | 存储驱动，`file` 已实现，`s3` 未实现（选它会启动失败） |
| `QTDATA_STORE_PATH` | `data` | 数据目录，每集合一个 JSON 文件 |
| `QTDATA_LOG_LEVEL` | `info` | `debug` / `info` / `warn` / `error` |
| `QTDATA_LOG_FORMAT` | `text` | `text` / `json` |

JSON 配置文件的键与字段名一致（`server.addr`、`store.driver`、`store.path`、`log.level`、`log.format`）。

## 自己验一遍

```bash
go build ./... && go vet ./... && go test ./...
```

服务的仓库地址是 `github.com/quanttide/qtdata-provider`；接口边界见[接口参考](../api-references/index.md)，实现与扩展见[开发指南](../dev-guide/index.md)。
