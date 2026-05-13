import subprocess
import time
from pathlib import Path

ASSETS_VIDEOS = Path(__file__).resolve().parent.parent.parent / "assets" / "videos"


class Recorder:
    def __init__(self, filename: str, output_dir: Path | None = None):
        output_dir = output_dir or ASSETS_VIDEOS
        self.path = output_dir / f"{filename}.mp4"
        self.proc = None

    def start(self):
        ASSETS_VIDEOS.mkdir(parents=True, exist_ok=True)
        self.proc = subprocess.Popen(
            [
                "ffmpeg",
                "-y",
                "-f",
                "x11grab",
                "-framerate",
                "10",
                "-video_size",
                "1920x1080",
                "-i",
                ":0.0",
                str(self.path),
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

    def stop(self):
        if self.proc:
            self.proc.terminate()
            self.proc.wait()
            self.proc = None
