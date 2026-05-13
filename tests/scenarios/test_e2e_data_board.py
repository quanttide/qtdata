from screens.home_screen import HomeScreen


def test_create_and_verify_tasks(client, provider_process):
    screen = HomeScreen(client)
    tasks_before = len(screen.get_tasks())

    screen.create_project("e2e-project")
    screen.create_task("E2E 测试任务", task_type="requirement")

    tasks = screen.get_tasks()
    assert len(tasks) == tasks_before + 1
    assert tasks[-1]["title"] == "E2E 测试任务"
