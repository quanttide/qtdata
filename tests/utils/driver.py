import subprocess
import time
from pathlib import Path

STUDIO_DIR = Path(__file__).resolve().parent.parent.parent / "src" / "studio"


class FlutterDriver:
    def __init__(self):
        self.proc = None

    def start(self, target: str = "lib/main.dart"):
        self.proc = subprocess.Popen(
            ["flutter", "run", "-d", "linux", target],
            cwd=STUDIO_DIR,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        time.sleep(5)

    def stop(self):
        if self.proc:
            self.proc.terminate()
            self.proc.wait()
            self.proc = None
