import time
from pathlib import Path

from utils.recorder import Recorder


def test_recorder_start_stop(tmp_path):
    r = Recorder("test_recording")
    r.start()
    time.sleep(1)
    r.stop()
    assert r.path.exists()
    assert r.path.suffix == ".mp4"
    assert r.path.stat().st_size > 0
