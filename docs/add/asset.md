# Asset 数据模型

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