# 任务

路由前缀 `/api/v1/qtdata/tasks`，落盘 `data/qtdata/tasks.json`（集合名 `qtdata/tasks`）。

## 字段

| 字段 | 类型 | 必填 | 说明 |
|:-----|:-----|:-----|:-----|
| `id` | string | 服务端分配 | 32 位十六进制 |
| `title` | string | 是 | 任务标题 |
| `description` | string | 否 | 说明，缺省不出现 |
| `type` | string | 否 | 沿用四类：`requirement` / `agreement` / `execution` / `acceptance` |
| `status` | string | 否 | 取值由调用方约定（示例用 `todo` / `done`） |
| `createdAt` | string | 服务端写入 | RFC3339 UTC |
| `updatedAt` | string | 服务端维护 | 创建时与 `createdAt` 同值，更新时刷新 |

字段名 camelCase，接续 Python 版 Task 能力的既有契约。

## 调用

```bash
curl -s -X POST http://127.0.0.1:8000/api/v1/qtdata/tasks \
  -d '{"title":"清洗课程档案","type":"execution","status":"todo"}'
```

```json
{"id":"341c7a7226bc707ffd622ede4082326b","title":"清洗课程档案","type":"execution","status":"todo","createdAt":"2026-10-21T04:06:48Z","updatedAt":"2026-10-21T04:06:48Z"}
```

整体替换（不带 `createdAt` 就会被清空，这是当前实现的实际行为）：

```bash
curl -s -X PUT http://127.0.0.1:8000/api/v1/qtdata/tasks/341c7a7226bc707ffd622ede4082326b \
  -d '{"title":"清洗课程档案","type":"execution","status":"done"}'
```

```json
{"id":"341c7a7226bc707ffd622ede4082326b","title":"清洗课程档案","type":"execution","status":"done","createdAt":"","updatedAt":"2026-10-21T04:06:51Z"}
```

删不存在的 id：

```bash
curl -s -X DELETE http://127.0.0.1:8000/api/v1/qtdata/tasks/341c7a7226bc707ffd622ede4082326b
```

```json
{"error":{"code":"NOT_FOUND","message":"qtdata/tasks not found"}}
```

`message` 里是集合名，不是 id。列表返回数组、按 `id` 排序；删除成功返回 `204`。
