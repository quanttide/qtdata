# 量潮数据

## 仓库结构

```
src/provider/              – Python FastAPI 服务端
  app/                     – 应用模块（main、storage）
src/studio/                – Flutter 客户端
  packages/              – 本地 Dart 功能包
  lib/                   – 主程序
tests/                     – 端到端测试
  screens/                 – 页面层（Page Object）
  usecases/                – 用例层（pytest 业务序列）
  utils/                   – 工具层（BasePage、截图、录屏）
docs/                      – 工作文档
  prd/                     – 产品需求文档（数据模型、功能定义）
  brd/                     – 业务需求文档（场景拆解、交付流程）
  add/                     – 架构设计文档（资产模块）
  dev/                     – 开发文档（测试策略、集成方案）
  ixd/                     – 交互设计文档（页面流程）
assets/                    – 资产
  images/                  – 截图
  videos/                  – 录屏
scripts/                   – 运行脚本（如 run-studio-linux.sh）
examples/                  – 示例与原型
  default/                 – 默认示例
  prototype/               – 交互原型
```
