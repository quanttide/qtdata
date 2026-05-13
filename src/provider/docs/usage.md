# QTData Provider — 使用文档

## 启动服务

```bash
uv run uvicorn app.main:app --reload
```

服务默认监听 `http://127.0.0.1:8000`。

## API 端点

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/health` | 健康检查 |
| GET | `/projects` | 项目列表 |
| POST | `/projects` | 创建项目 |
| GET | `/projects/{id}` | 获取项目详情 |
| PUT | `/projects/{id}` | 更新项目 |
| DELETE | `/projects/{id}` | 删除项目 |
| GET | `/tasks` | 任务列表 |
| POST | `/tasks` | 创建任务 |
| GET | `/tasks/{id}` | 获取任务详情 |
| PUT | `/tasks/{id}` | 更新任务 |
| DELETE | `/tasks/{id}` | 删除任务 |

交互式 API 文档：`http://127.0.0.1:8000/docs`

## 运行测试

```bash
uv run pytest test/ -v
```

## 项目结构

```
src/provider/
├── app/          # 应用代码
│   ├── __init__.py
│   └── main.py
├── test/         # 测试
│   ├── __init__.py
│   └── test_main.py
├── docs/         # 文档
│   └── usage.md
├── pyproject.toml
├── uv.lock
└── .gitignore
```
