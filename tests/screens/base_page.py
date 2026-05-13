import subprocess
import time
from pathlib import Path

import pytesseract
from PIL import Image

from utils.screenshot import capture_window


class BasePage:
    WINDOW_TITLE = "量潮数据"

    def _window_id(self):
        result = subprocess.run(
            ["xdotool", "search", "--name", self.WINDOW_TITLE],
            capture_output=True, text=True, timeout=5,
        )
        return result.stdout.strip().split("\n")[0] if result.stdout.strip() else None

    def focus(self):
        wid = self._window_id()
        if wid:
            subprocess.run(["xdotool", "windowactivate", wid], timeout=5)

    def resize(self, width: int, height: int):
        wid = self._window_id()
        if wid:
            subprocess.run(["xdotool", "windowsize", wid, str(width), str(height)], timeout=5)

    def click(self, x: int, y: int):
        self.focus()
        time.sleep(0.3)
        subprocess.run(["xdotool", "mousemove", str(x), str(y), "click", "1"], timeout=5)

    def type_text(self, text: str):
        subprocess.run(["xdotool", "type", text], timeout=5)

    def press_key(self, key: str):
        subprocess.run(["xdotool", "key", key], timeout=5)

    def screenshot(self, name: str) -> str:
        self.focus()
        time.sleep(0.5)
        return capture_window(name, self.WINDOW_TITLE)

    def assert_text_visible(self, text: str, screenshot_path: str | None = None, lang: str = "chi_sim+eng"):
        if screenshot_path is None:
            screenshot_path = self.screenshot("ocr_check")
        ocr_text = pytesseract.image_to_string(Image.open(screenshot_path), lang=lang)
        assert text in ocr_text, f"Expected '{text}' not found in screenshot.\nOCR result:\n{ocr_text}"
