from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_projects_demo_data():
    response = client.get("/projects")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 3
    assert data[0]["id"] == "p1"
    assert data[0]["title"] == "数据项目 1"
    assert "createdAt" in data[0]
    assert "updatedAt" in data[0]


def test_tasks_demo_data():
    response = client.get("/tasks")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 15
    assert data[0]["type"] == "requirement"
    assert data[0]["id"] == "r1"
    assert "createdAt" in data[0]
    assert "updatedAt" in data[0]


def test_four_types_present():
    response = client.get("/tasks")
    types = {t["type"] for t in response.json()}
    assert types == {"requirement", "agreement", "execution", "acceptance"}


def test_create_project():
    response = client.post("/projects", json={
        "id": "p99",
        "name": "new-project",
        "title": "新项目",
    })
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "p99"
    assert data["title"] == "新项目"
    assert data["createdAt"] is not None


def test_create_task():
    response = client.post("/tasks", json={
        "id": "t99",
        "title": "新任务",
        "type": "execution",
        "status": "todo",
    })
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == "t99"
    assert data["type"] == "execution"
    assert data["status"] == "todo"


def test_get_not_found():
    assert client.get("/projects/none").status_code == 404
    assert client.get("/tasks/none").status_code == 404


def test_delete():
    client.post("/projects", json={"id": "p-del", "name": "d", "title": "D"})
    assert client.delete("/projects/p-del").status_code == 200
    assert client.get("/projects/p-del").status_code == 404


def test_update_project():
    client.post("/projects", json={"id": "p-upd", "name": "old", "title": "Old"})
    response = client.patch("/projects/p-upd", json={"title": "New"})
    assert response.status_code == 200
    assert response.json()["title"] == "New"
