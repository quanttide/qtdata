# 数据集

路由前缀 `/api/v1/qtdata/datasets`，落盘 `data/qtdata/datasets.json`（集合名 `qtdata/datasets`）。

## 字段

| 字段 | 类型 | 必填 | 说明 |
|:-----|:-----|:-----|:-----|
| `id` | string | 服务端分配 | 32 位十六进制 |
| `name` | string | 是 | 数据集名 |
| `description` | string | 否 | 说明 |
| `version` | string | 否 | 版本号，如 `v0.1.0` |
| `status` | string | 否 | 状态，取值由调用方约定（示例用 `draft`） |
| `created_at` | string | 服务端写入 | RFC3339 UTC |

字段名是 snake_case——沿用整合前 `/api/v1/qtdata/datasets` 的既有契约，和项目、任务两个资源不同。

## 调用

建一个：

```bash
curl -s -X POST http://127.0.0.1:8000/api/v1/qtdata/datasets \
  -d '{"name":"课程档案","description":"实训基地课程档案数据集","version":"v0.1.0","status":"draft"}'
```

```json
{"id":"67f93079f42d829a96bdc1e82c1a5bc9","name":"课程档案","description":"实训基地课程档案数据集","version":"v0.1.0","status":"draft","created_at":"2026-10-21T04:06:48Z"}
```

缺 `name`：

```bash
curl -s -X POST http://127.0.0.1:8000/api/v1/qtdata/datasets -d '{}'
```

```json
{"error":{"code":"VALIDATION_ERROR","message":"name is required"}}
```

取详情、整体替换、删除：

```bash
curl -s http://127.0.0.1:8000/api/v1/qtdata/datasets/67f93079f42d829a96bdc1e82c1a5bc9
curl -s -X PUT http://127.0.0.1:8000/api/v1/qtdata/datasets/67f93079f42d829a96bdc1e82c1a5bc9 \
  -d '{"name":"课程档案","status":"ready"}'
curl -s -o /dev/null -w "%{http_code}\n" -X DELETE \
  http://127.0.0.1:8000/api/v1/qtdata/datasets/67f93079f42d829a96bdc1e82c1a5bc9
```

删除成功是 `204`；删不存在的 id 返回 `404 NOT_FOUND`。`PUT` 是整体替换，没带的 `created_at` 会丢（见[接口参考](index.md)·更新是整体替换）。
