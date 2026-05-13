from pathlib import Path

from utils.screenshot import capture
from utils.screenshot import ASSETS_IMAGES


def test_capture_fullscreen():
    path = capture("test_fullscreen")
    assert Path(path).exists()
    assert Path(path).suffix == ".png"


def test_capture_window_fallback():
    path = capture("test_nonexistent_window", window_title="__NONEXISTENT_WINDOW__")
    assert Path(path).exists()
    assert Path(path).suffix == ".png"
