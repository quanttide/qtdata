# QTData Provider 使用文档

## 启动服务

```bash
cd src/provider
go run ./cmd/server
```

服务默认监听 `http://127.0.0.1:8000`。

## API 端点

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/health` | 健康检查 |
| GET / POST | `/api/v1/qtdata/projects` | 项目列表 / 创建项目 |
| GET / PUT / DELETE | `/api/v1/qtdata/projects/{id}` | 项目详情 / 更新 / 删除 |
| GET / POST | `/api/v1/qtdata/tasks` | 任务列表 / 创建任务 |
| GET / PUT / DELETE | `/api/v1/qtdata/tasks/{id}` | 任务详情 / 更新 / 删除 |
| GET / POST | `/api/v1/qtdata/datasets` | 数据集列表 / 创建数据集 |
| GET / PUT / DELETE | `/api/v1/qtdata/datasets/{id}` | 数据集详情 / 更新 / 删除 |

统一语义：创建返回 `201`，由服务端分配 `id`；更新为 `PUT` 整体替换；删除成功返回 `204`；错误响应为 `{"error": {"code": "...", "message": "..."}}`（`INVALID_INPUT` / `VALIDATION_ERROR` / `NOT_FOUND` / `INTERNAL_ERROR`）。

必填校验：数据集与项目 `name` 必填，任务 `title` 必填。项目与任务的 `createdAt` / `updatedAt` 由服务端维护。

## 配置

配置来源优先级：环境变量 > JSON 文件（`CONFIG_PATH`）> 默认值。

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `QTDATA_ADDR` | `:8000` | 监听地址 |
| `QTDATA_STORE_DRIVER` | `file` | 存储驱动（`file` / `s3` 预留） |
| `QTDATA_STORE_PATH` | `data` | 数据目录，每集合一个 JSON 文件 |
| `QTDATA_LOG_LEVEL` | `info` | 日志级别（debug / info / warn / error） |
| `QTDATA_LOG_FORMAT` | `text` | 日志格式（text / json） |

无前缀的 `ADDR`、`STORE_DRIVER`、`STORE_PATH`、`LOG_LEVEL`、`LOG_FORMAT` 仍可用；`QTDATA_*` 优先。

## 运行测试

```bash
go vet ./... && go test ./...
```

## 项目结构

```
src/provider/
├── cmd/server/        # 服务装配（config → store → 路由 → 日志 → 优雅关闭）
├── internal/
│   ├── api/           # 路由与处理器（health + 三资源 CRUD）
│   ├── config/        # 配置加载（JSON + 环境变量）
│   ├── model/         # 资源模型（project / task / dataset）
│   ├── store/         # 存储抽象（file 驱动，S3 预留）
│   └── version/       # 版本号
├── docs/usage.md      # 本文档
├── go.mod
├── CHANGELOG.md
└── ROADMAP.md
```
