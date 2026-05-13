# E2E 测试工具

工具层（`tests/utils/`）和页面层（`tests/screens/`）共同提供 E2E 测试所需的操作能力。

按测试调用顺序组织：先通过页面对象准备数据，再操作 UI 并断言，最后用录制/截图工具记录结果。

## 页面层

`tests/screens/` 封装业务页面操作。

`HomeScreen` 继承 `BasePage`，封装数据看板特有的 API 操作：

- `get_projects()` / `get_tasks()` — 获取项目/任务列表
- `create_project(name)` / `create_task(title)` — 创建项目/任务

## 工具层

`tests/utils/` 提供窗口操作基类和录制/截图工具。

`BasePage` 封装 xdotool 窗口自动化操作：

| 方法 | 作用 |
|:-----|:-----|
| `focus()` | 激活窗口 |
| `resize(w, h)` | 调整窗口尺寸 |
| `click(x, y)` | 模拟鼠标点击 |
| `type_text(text)` | 模拟键盘输入 |
| `press_key(key)` | 模拟按键 |
| `screenshot(name)` | 截取当前窗口 |
| `assert_text_visible(text)` | OCR 验证页面文字 |

窗口标题默认 `"量潮数据"`，子类可覆写 `WINDOW_TITLE`。

`screenshot.py` 提供两种截图方式：

- `capture(filename)` — 全屏截图
- `capture_window(filename, window_title)` — 按窗口标题截取，`BasePage.screenshot()` 内部调用

通过 `xdotool` 定位窗口、`mss` 截取，输出路径通过 `output_dir` 指定，默认写入 `assets/images/`。

`recorder.py` 提供屏幕录制：

- `Recorder(filename)` — 创建录制任务，调用 `start()` / `stop()` 控制
- 输出路径通过 `output_dir` 指定，默认写入 `assets/videos/`
