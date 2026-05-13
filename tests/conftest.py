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
    yield proc
    proc.terminate()
    proc.wait()


@pytest.fixture(scope="session")
def client(provider_url, provider_process):
    with httpx.Client(base_url=provider_url) as c:
        yield c
