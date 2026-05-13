from pathlib import Path

from utils.screenshot import capture, capture_window


def test_capture():
    path = capture("test_fullscreen")
    assert Path(path).exists()
    assert Path(path).suffix == ".png"


def test_capture_window_not_found():
    import pytest
    with pytest.raises(RuntimeError, match="Window.*not found"):
        capture_window("test_no_window", "__NONEXISTENT_WINDOW__")
