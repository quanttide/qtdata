# 项目

路由前缀 `/api/v1/qtdata/projects`，落盘 `data/qtdata/projects.json`（集合名 `qtdata/projects`）。

## 字段

| 字段 | 类型 | 必填 | 说明 |
|:-----|:-----|:-----|:-----|
| `id` | string | 服务端分配 | 32 位十六进制 |
| `name` | string | 是 | 项目名 |
| `title` | string | 否 | 展示标题 |
| `createdBy` | string | 否 | 创建人标识，缺省不出现 |
| `createdAt` | string | 服务端写入 | RFC3339 UTC |
| `updatedAt` | string | 服务端维护 | 创建时与 `createdAt` 同值，更新时刷新 |

字段名 camelCase，接续 Python 版 Project 能力的既有契约。

## 调用

```bash
curl -s -X POST http://127.0.0.1:8000/api/v1/qtdata/projects -d '{"name":"qtdata","title":"数据云"}'
```

```json
{"id":"373e1fb212a75a0854c0fae405ebed43","name":"qtdata","title":"数据云","createdAt":"2026-10-21T04:06:48Z","updatedAt":"2026-10-21T04:06:48Z"}
```

请求体不是合法 JSON：

```bash
curl -s -X POST http://127.0.0.1:8000/api/v1/qtdata/projects -d 'not-json'
```

```json
{"error":{"code":"INVALID_INPUT","message":"invalid request body"}}
```

`GET /api/v1/qtdata/projects` 返回数组，按 `id` 排序；`PUT` 整体替换；`DELETE` 成功返回 `204`。整体替换的注意事项见[接口参考](index.md)·更新是整体替换。
