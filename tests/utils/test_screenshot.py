from pathlib import Path

from utils.screenshot import capture


def test_capture(tmp_path):
    path = capture("test_smoke")
    assert Path(path).exists()
    assert Path(path).suffix == ".png"
