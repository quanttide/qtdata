from pathlib import Path
from unittest.mock import MagicMock, patch

import pytest

from utils.screenshot import capture, capture_window


def test_capture(tmp_path):
    path = capture("test_screenshot", output_dir=tmp_path)
    assert Path(path).exists()
    assert Path(path).suffix == ".png"


def test_capture_window_not_found():
    with pytest.raises(RuntimeError, match="Window.*not found"):
        capture_window("test_no_window", "__NONEXISTENT_WINDOW__")


@patch("utils.screenshot.mss_tools.to_png")
@patch("utils.screenshot.mss.MSS")
@patch("utils.screenshot.subprocess.run")
def test_capture_window_success(mock_run, mock_mss, mock_to_png, tmp_path):
    mock_run.side_effect = [
        MagicMock(stdout="12345\n"),
        MagicMock(stdout="  window id: 12345\n  Position: 100,200\n  Geometry: 800x600\n"),
    ]

    mock_img = MagicMock()
    mock_img.rgb = b"fake"
    mock_img.size = (800, 600)
    mock_sct = MagicMock()
    mock_sct.grab.return_value = mock_img
    mock_mss.return_value.__enter__.return_value = mock_sct

    def fake_to_png(rgb, size, output):
        Path(output).touch()

    mock_to_png.side_effect = fake_to_png

    path = capture_window("test_window", "TestApp", output_dir=tmp_path)

    assert path == str(tmp_path / "test_window.png")
    assert Path(path).exists()
    mock_sct.grab.assert_called_once_with({
        "left": 100, "top": 200, "width": 800, "height": 600,
    })
