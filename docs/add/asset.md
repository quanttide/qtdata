# 资产管理架构

## 系统架构

```
┌─────────────────────────────────────────────┐
│              客户门户 (ixd)                │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│              资产服务 (Asset)              │
│  - 资产元数据                              │
│  - S3文件引用                              │
│  - 状态流转                                │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│              S3对象存储                    │
└─────────────────────────────────────────────┘
```

## 资产模型

```
Asset {
  id: string
  title: string
  description: string
  category: enum[dataset, processor, document]
  name: string
  content: string
  status: enum[draft, ready, archived]
  created_at: datetime
  updated_at: datetime
}
```