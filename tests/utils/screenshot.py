import subprocess
from pathlib import Path

ASSETS_IMAGES = Path(__file__).resolve().parent.parent.parent / "assets" / "images"


def capture(filename: str, window_title: str = ""):
    """Capture screenshot to assets/images/{filename}.png.

    If window_title is given, capture only that window.
    Otherwise capture full screen.
    """
    ASSETS_IMAGES.mkdir(parents=True, exist_ok=True)
    path = str(ASSETS_IMAGES / f"{filename}.png")

    if window_title:
        try:
            wid = subprocess.run(
                ["xdotool", "search", "--name", window_title],
                capture_output=True, text=True, timeout=5,
            )
            if wid.stdout.strip():
                subprocess.run(
                    ["import", "-window", wid.stdout.strip().split("\n")[0], path],
                    timeout=10,
                )
                return path
        except (FileNotFoundError, subprocess.TimeoutExpired, IndexError):
            pass

    import mss

    with mss.MSS() as sct:
        sct.shot(output=path)
    return path
