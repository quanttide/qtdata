# qtdata Studio

qtdata 的观测面——项目的进度、数据流程、交付资产在这里被人看见（意图：「平台的正确视角是观测整个系统，而不是思考流程」）。

## 形态

| 平台 | 状态 |
|---|---|
| Web | 产品形态。CI 在 `studio/*` tag 上构建并发到 OSS 桶 `qtdata-studio`，入口 `studio.data.quanttide.com` |
| Linux 桌面 | 本地开发形态，`../scripts/run-studio-linux.sh` 构建并启动 |
| Android / iOS / macOS / Windows | 脚手架已在仓里，**尚未构建验证过**，需要完善 |

## 跑起来

```bash
flutter run -d linux      # 桌面调试
flutter run -d chrome     # 浏览器调试（Web 形态）
../scripts/run-studio-linux.sh   # 一次性构建 release bundle 并启动
```

## 门禁

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

三条现在都要手工跑——CI 还没接（见 [TODO.md](./TODO.md) 一段）。

## 结构

```
lib/main.dart                    装配 MaterialApp
lib/project/                     项目域：models/ views/ screens/
lib/data/                        数据域：models/ views/ screens/
lib/business/                    商务域：models/ views/ screens/
lib/asset/                       资产域：交付物与交付矩阵（三域 × 五阶段）
lib/app/                         跨域共用：全局侧栏/断点、区块标题、详情页外壳、总览 Tab
assets/data/                     界面数据（现在是 seed JSON，将来换成 Provider）
fonts/                           自带字体：Noto Sans SC 子集（400/500/600/700 四档，含 6 个 emoji 字形），文字渲染不依赖 fonts.gstatic.com
doc/                             页面分解原型（index/project 两页，Flutter 实现之前的设计）
test/{app,data,project,business,asset}/{models,views,screens}/   跟着 lib/ 同名同构（12 文件 21 用例）
```

## 文档索引

| 文档 | 用途 |
|---|---|
| [STATUS.md](./STATUS.md) | 对照软件工程契约的体检：结构 / 依赖 / 平台条款逐条判定 |
| [TODO.md](./TODO.md) | 待办：改什么 / 判据（可跑命令）/ 影响哪些文件 |
| [ROADMAP.md](./ROADMAP.md) | 路线：为什么做、分五段、现在在哪 |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | 开发约定：分层名义、选型、门禁三连、依赖规矩 |
| [doc/index.md](./doc/index.md)、[doc/project.md](./doc/project.md) | 页面分解：两页的区块、交互与数据 |
| [CHANGELOG.md](./CHANGELOG.md) | 版本记录 |
