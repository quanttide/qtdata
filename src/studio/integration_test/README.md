# integration_test — Flutter 进程内端到端

边界：**Flutter 进程内**的端到端业务流（真 app 装配、真 seed 数据、真路由）。

- 与 `src/studio/test/`（部件/页面级，`flutter test`）不重叠：这里从 `main()` 起跑完整 app
- 与仓库根 `tests/`（pytest + xdotool，跨进程驱动桌面窗口 + provider）不重叠：这里不碰进程与窗口

跑法（需要 Linux 桌面与显示环境）：

```bash
cd src/studio
flutter test integration_test -d linux
```
