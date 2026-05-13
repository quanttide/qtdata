# 工具层

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
