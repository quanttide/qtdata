import subprocess
import time


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
