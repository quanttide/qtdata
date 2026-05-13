from utils.home_screen import HomeScreen


def test_provider_only(client, provider_process):
    screen = HomeScreen(client)
    tasks_before = len(screen.get_tasks())

    screen.create_task("API only 测试", task_type="requirement")

    tasks = screen.get_tasks()
    assert len(tasks) == tasks_before + 1


def test_flutter_window(flutter_process):
    screen = HomeScreen(None)
    wid = screen._window_id()
    assert wid is not None, "Flutter window not found"
