from unittest.mock import MagicMock, patch

import pytest

from utils.base_page import BasePage


@pytest.fixture
def page():
    return BasePage()


@patch("utils.base_page.subprocess.run")
def test_window_id_found(mock_run, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    assert page._window_id() == "12345"
    mock_run.assert_called_once_with(
        ["xdotool", "search", "--name", "量潮数据"],
        capture_output=True, text=True, timeout=5,
    )


@patch("utils.base_page.subprocess.run")
def test_window_id_not_found(mock_run, page):
    mock_run.return_value = MagicMock(stdout="")
    assert page._window_id() is None


@patch("utils.base_page.subprocess.run")
def test_focus(mock_run, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    page.focus()
    assert mock_run.call_count == 2


@patch("utils.base_page.subprocess.run")
def test_focus_no_window(mock_run, page):
    mock_run.return_value = MagicMock(stdout="")
    page.focus()
    mock_run.assert_called_once()


@patch("utils.base_page.subprocess.run")
def test_resize(mock_run, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    page.resize(1024, 768)
    mock_run.assert_any_call(
        ["xdotool", "windowsize", "12345", "1024", "768"], timeout=5,
    )


@patch("utils.base_page.subprocess.run")
@patch("utils.base_page.time.sleep")
def test_click(mock_sleep, mock_run, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    page.click(100, 200)
    mock_run.assert_any_call(
        ["xdotool", "mousemove", "100", "200", "click", "1"], timeout=5,
    )


@patch("utils.base_page.subprocess.run")
def test_type_text(mock_run, page):
    page.type_text("hello")
    mock_run.assert_called_once_with(["xdotool", "type", "hello"], timeout=5)


@patch("utils.base_page.subprocess.run")
def test_press_key(mock_run, page):
    page.press_key("Return")
    mock_run.assert_called_once_with(["xdotool", "key", "Return"], timeout=5)


@patch("utils.base_page.capture_window")
@patch("utils.base_page.subprocess.run")
@patch("utils.base_page.time.sleep")
def test_screenshot(mock_sleep, mock_run, mock_capture, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    mock_capture.return_value = "/tmp/screen.png"
    assert page.screenshot("test") == "/tmp/screen.png"
    mock_capture.assert_called_once_with("test", "量潮数据")


@patch("utils.base_page.capture_window")
@patch("utils.base_page.subprocess.run")
@patch("utils.base_page.pytesseract.image_to_string")
@patch("utils.base_page.Image.open")
@patch("utils.base_page.time.sleep")
def test_assert_text_visible_found(mock_sleep, mock_img_open, mock_ocr, mock_run, mock_capture, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    mock_capture.return_value = "/tmp/test.png"
    mock_ocr.return_value = "量潮数据 platform"
    page.assert_text_visible("量潮数据")


@patch("utils.base_page.capture_window")
@patch("utils.base_page.subprocess.run")
@patch("utils.base_page.pytesseract.image_to_string")
@patch("utils.base_page.Image.open")
@patch("utils.base_page.time.sleep")
def test_assert_text_visible_not_found(mock_sleep, mock_img_open, mock_ocr, mock_run, mock_capture, page):
    mock_run.return_value = MagicMock(stdout="12345\n")
    mock_capture.return_value = "/tmp/test.png"
    mock_ocr.return_value = "other content"
    with pytest.raises(AssertionError, match="Expected '量潮数据' not found"):
        page.assert_text_visible("量潮数据")


@patch("utils.base_page.pytesseract.image_to_string")
@patch("utils.base_page.Image.open")
def test_assert_text_visible_with_path(mock_img_open, mock_ocr, page):
    mock_ocr.return_value = "found text"
    page.assert_text_visible("found text", screenshot_path="/some/path.png")
    mock_ocr.assert_called_once()
