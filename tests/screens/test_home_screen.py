from unittest.mock import MagicMock

from screens.home_screen import HomeScreen


def test_get_projects():
    client = MagicMock()
    client.get.return_value.json.return_value = [{"id": "1", "name": "p1"}]
    screen = HomeScreen(client)
    assert screen.get_projects() == [{"id": "1", "name": "p1"}]
    client.get.assert_called_once_with("/projects")


def test_get_tasks():
    client = MagicMock()
    client.get.return_value.json.return_value = [{"id": "1", "title": "t1"}]
    screen = HomeScreen(client)
    assert screen.get_tasks() == [{"id": "1", "title": "t1"}]
    client.get.assert_called_once_with("/tasks")


def test_create_project():
    client = MagicMock()
    client.post.return_value.json.return_value = {"id": "proj1", "name": "proj1"}
    screen = HomeScreen(client)
    assert screen.create_project("proj1") == {"id": "proj1", "name": "proj1"}
    client.post.assert_called_once_with(
        "/projects", json={"id": "proj1", "name": "proj1", "title": "proj1"},
    )


def test_create_task():
    client = MagicMock()
    client.post.return_value.json.return_value = {"id": "task1", "title": "task1"}
    screen = HomeScreen(client)
    assert screen.create_task("task1") == {"id": "task1", "title": "task1"}
    client.post.assert_called_once_with(
        "/tasks", json={"id": "task1", "title": "task1", "type": "requirement"},
    )


def test_create_task_custom_type():
    client = MagicMock()
    client.post.return_value.json.return_value = {"id": "task2", "title": "bug"}
    screen = HomeScreen(client)
    assert screen.create_task("bug", task_type="bug") == {"id": "task2", "title": "bug"}
    client.post.assert_called_once_with(
        "/tasks", json={"id": "bug", "title": "bug", "type": "bug"},
    )
