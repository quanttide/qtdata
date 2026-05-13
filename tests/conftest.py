import subprocess
import sys
import time
from pathlib import Path

import httpx
import pytest

PROJECT_ROOT = Path(__file__).resolve().parent.parent


@pytest.fixture(scope="session")
def provider_url():
    return "http://localhost:8000"


@pytest.fixture(scope="session")
def provider_process(provider_url):
    proc = subprocess.Popen(
        [sys.executable, "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"],
        cwd=PROJECT_ROOT / "src/provider",
    )
    for _ in range(30):
        try:
            resp = httpx.get(f"{provider_url}/health", timeout=1)
            if resp.status_code == 200:
                break
        except httpx.ConnectError:
            pass
        time.sleep(0.5)
    else:
        proc.terminate()
        raise RuntimeError("Provider failed to start within 15s")
    resp = httpx.get(f"{provider_url}/health")
    body = resp.json()
    assert body == {"status": "ok"}, f"Unexpected health response: {body}"
    yield proc
    proc.terminate()
    proc.wait()


@pytest.fixture(scope="session")
def client(provider_url, provider_process):
    with httpx.Client(base_url=provider_url) as c:
        resp = c.get("/health")
        assert resp.status_code == 200
        assert resp.json() == {"status": "ok"}
        yield c


@pytest.fixture(scope="session")
def flutter_process():
    STUDIO_DIR = PROJECT_ROOT / "src/studio"
    proc = subprocess.Popen(
        ["flutter", "run", "-d", "linux"],
        cwd=STUDIO_DIR,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    time.sleep(10)
    result = subprocess.run(
        ["xdotool", "search", "--name", "量潮数据"],
        capture_output=True, text=True, timeout=5,
    )
    if not result.stdout.strip():
        proc.terminate()
        proc.wait()
        raise RuntimeError("Flutter window not found after 10s")
    yield proc
    proc.terminate()
    proc.wait()
