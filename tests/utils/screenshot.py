from pathlib import Path

ASSETS_IMAGES = Path(__file__).resolve().parent.parent.parent / "assets" / "images"


def capture(filename: str):
    """Capture full screen to assets/images/{filename}.png."""
    import mss

    ASSETS_IMAGES.mkdir(parents=True, exist_ok=True)
    path = str(ASSETS_IMAGES / f"{filename}.png")
    with mss.MSS() as sct:
        sct.shot(output=path)
    return path
