import subprocess
from pathlib import Path

import mss
from mss import tools as mss_tools

ASSETS_IMAGES = Path(__file__).resolve().parent.parent.parent / "assets" / "images"


def capture(filename: str):
    ASSETS_IMAGES.mkdir(parents=True, exist_ok=True)
    path = str(ASSETS_IMAGES / f"{filename}.png")
    with mss.MSS() as sct:
        sct.shot(output=path)
    return path


def capture_window(filename: str, window_title: str):
    ASSETS_IMAGES.mkdir(parents=True, exist_ok=True)
    path = str(ASSETS_IMAGES / f"{filename}.png")

    result = subprocess.run(
        ["xdotool", "search", "--name", window_title],
        capture_output=True, text=True, timeout=5,
    )
    if not result.stdout.strip():
        raise RuntimeError(f"Window '{window_title}' not found")
    wid = result.stdout.strip().split("\n")[0]

    geo = subprocess.run(
        ["xdotool", "getwindowgeometry", wid],
        capture_output=True, text=True, timeout=5,
    )
    lines = geo.stdout.strip().split("\n")
    pos_part = lines[1].split("Position:")[1].strip().split(" ")[0]
    pos_x, pos_y = pos_part.split(",")
    size_part = lines[2].split("Geometry:")[1].strip()
    size_w, size_h = size_part.split("x")
    region = {
        "left": int(pos_x), "top": int(pos_y),
        "width": int(size_w), "height": int(size_h),
    }

    with mss.MSS() as sct:
        img = sct.grab(region)
        mss_tools.to_png(img.rgb, img.size, output=path)
    return path
