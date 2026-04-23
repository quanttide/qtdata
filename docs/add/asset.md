# 资产管理架构

## 系统架构

```
┌─────────────────────────────────────────────┐
│              客户门户 (ixd)                │
│  - 项目概览                                  │
│  - 进度追踪                                  │
│  - 资产浏览                                 │
│  - 验收流程                                 │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│              资产服务 API                   │
│  - 资产 CRUD                               │
│  - 项目管理                                 │
│  - 状态流转                                 │
│  - 版本管理                                 │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│              数据存储                       │
│  - PostgreSQL: 项目、资产元数据           │
│  - MinIO: 数据文件存储                     │
│  - Git: 代码仓库                           │
└─────────────────────────────────────────────┘
```

## 核心模块

### 1. 资产服务

负责资产的CRUD和版本管理：

```
AssetService {
  create_asset(asset): Asset
  get_asset(id): Asset
  list_assets(filters): Asset[]
  update_asset(id, asset): Asset
  delete_asset(id): void
  create_version(asset_id, version): AssetVersion
}
```

### 2. 项目服务

负责项目管理：

```
ProjectService {
  create_project(customer_id, name): Project
  get_project(id): Project
  list_projects(filters): Project[]
  update_status(id, status): Project
  add_asset(project_id, asset_id): void
}
```

### 3. 文件服务

负责数据文件存储：

```
FileService {
  upload(file): FileInfo
  download(file_id): Stream
  preview(file_id): Preview
}
```

## 技术选型

- 后端：Python/FastAPI
- 前端：React + Ant Design
- 数据库：PostgreSQL
- 对象存储：MinIO
- 代码仓库：Git (GitHub)