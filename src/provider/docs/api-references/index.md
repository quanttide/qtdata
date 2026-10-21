# 接口参考

三个资源共用一套写法：集合路径支持 `GET` 列表与 `POST` 创建，`/{id}` 支持 `GET` / `PUT` / `DELETE`。一份资源一篇：[数据集](datasets.md)、[项目](projects.md)、[任务](tasks.md)。

## 路径

| 方法 | 路径 | 说明 |
|:-----|:-----|:-----|
| GET | `/health` | 健康检查，返回 `{"status":"ok"}` |
| GET | `/api/v1/qtdata/datasets` | 数据集列表，返回数组 |
| POST | `/api/v1/qtdata/datasets` | 创建数据集 |
| GET | `/api/v1/qtdata/datasets/{id}` | 数据集详情 |
| PUT | `/api/v1/qtdata/datasets/{id}` | 整体替换数据集 |
| DELETE | `/api/v1/qtdata/datasets/{id}` | 删除数据集 |
| — | `/api/v1/qtdata/projects`、`/api/v1/qtdata/tasks` | 同上五个动作 |

## 状态码

| 场景 | 状态码 | 响应体 |
|:-----|:-------|:-------|
| 创建成功 | `201` | 创建后的对象，`id` 由服务端分配（32 位十六进制） |
| 列表 / 详情 / 更新成功 | `200` | 数组 / 对象 |
| 删除成功 | `204` | 空 |
| 请求体不是合法 JSON | `400` `INVALID_INPUT` | `{"error":{"code","message"}}` |
| 必填字段缺失 | `400` `VALIDATION_ERROR` | 同上，`message` 指出哪个字段 |
| 对象不存在（详情 / 更新 / 删除） | `404` `NOT_FOUND` | 同上，`message` 是集合名 |
| 存储读写或序列化失败 | `500` `INTERNAL_ERROR` | 同上 |

错误响应统一是 `{"error": {"code": "…", "message": "…"}}`，`Content-Type: application/json`。

## 更新是整体替换

`PUT` 用一个新对象覆盖旧记录：请求体里没出现的字段会成为零值。`onUpdate` 只刷新 `updatedAt`，不补别的字段，所以**整体替换会把 `createdAt` 清空**（实测：PUT 一个任务后返回 `"createdAt":""`）。要保住创建时间，客户端得把 `createdAt` 原样回传。

## 时间字段

`project` 与 `task` 有 `createdAt` / `updatedAt`，格式 RFC3339 UTC（`2026-10-21T04:06:48Z`），由服务端在创建时写入、更新时刷新 `updatedAt`。`dataset` 只有 `created_at`（snake_case，创建时写入），没有 `updatedAt`——字段名沿用整合前 `/api/v1/qtdata/datasets` 的既有契约。

## 校验

数据集与项目 `name` 必填，任务 `title` 必填。其余字段不做校验，`type` / `status` 这类取值由调用方约定（任务 `type` 沿用 `requirement` / `agreement` / `execution` / `acceptance` 四类）。
