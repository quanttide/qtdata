# 端到端测试

测试服务端、客户端、命令行工具的真实对接状况。

启动服务端、客户端，使用 xdotool 驱动 Flutter 窗口，验证数据链路正常。

## 分层设计

E2E 测试按职责分四层：

- **基础设施层** — pytest fixture（`conftest.py`）：provider 启停、Flutter app 启停、窗口管理
- **操作层** — Page Object（`screens/`）：按屏幕封装 xdotool 窗口操作和坐标定位
- **场景层** — pytest test cases（`scenarios/`）：业务交互序列
- **表达层** — 录制/截图工具（`utils/`）：记录和呈现测试过程与结果

原则：场景层不知"怎么点击"，操作层不知"录不录制"。每层只关心自己职责，独立可替换。

## 技术栈

| 工具 | 用途 |
|------|------|
| xdotool | 窗口查找、激活、坐标点击 |
| mss | 截图 |
| pytesseract | OCR 文字识别（验证页面内容） |
| Pillow | 图像处理 |
| httpx | Provider API 调用（数据准备、状态校验） |
| pytest | 用例编排与断言 |
| ffmpeg | 录屏 |

## 产物交付

表达层产出的截图和录屏交付至项目根目录的 `assets/` 下，按类型归类：

- `assets/images/` — 关键步骤截图
- `assets/videos/` — 完整测试流程录屏

产物作为版本化资产随仓库管理，可供文档、演示等场景直接引用复用。

> 图片和视频使用 Git LFS 管理，参见 `.gitattributes`。
