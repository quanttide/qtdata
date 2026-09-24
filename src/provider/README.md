# Provider（qtdata-provider）

量潮数据 Go 服务端：服务骨架（config / store / 日志 / 优雅关闭）+ qtdata 领域 CRUD。

## 资源与路由

| 领域 | 路由 |
|:-----|:-----|
| 健康检查 | `GET /health` |
| 数据集 | `/api/v1/qtdata/datasets`（CRUD，自 `examples/dataset-api` 整合） |
| 项目 | `/api/v1/qtdata/projects`（CRUD，接续 Python 版 Project 能力） |
| 任务 | `/api/v1/qtdata/tasks`（CRUD，接续 Python 版 Task 能力） |

## 结构

model（Project / Task / QtDataDataset）+ api（三个资源复用同一套五动作 CRUD）+ store（filestore 本地 JSON 持久化，S3 预留）+ config / version / cmd（服务装配）。

## 启动

```bash
cd src/provider
go run ./cmd/server
```

默认监听 `:8000`。配置通过环境变量或 `CONFIG_PATH` 指向的 JSON 文件设定（见 `docs/usage.md`）。

## 验证

```bash
go build ./... && go vet ./... && go test ./...
```

## 历史

- Python FastAPI 版见 CHANGELOG `provider/v0.0.1`（2026-05-14）；2026-09-24 全量重写为 Go
- 数据集域原自 qtadmin provider 拆出为 `examples/dataset-api` 参考实现，同日整合回本服务
