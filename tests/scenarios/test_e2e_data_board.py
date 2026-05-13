from screens.home_screen import HomeScreen


def test_create_data_and_verify_ui(client, appium_driver, provider_process):
    screen = HomeScreen(appium_driver, client)

    screen.create_project("e2e-project")
    screen.create_task("E2E 测试任务", task_type="requirement")

    tasks = screen.get_tasks()
    assert any(t["title"] == "E2E 测试任务" for t in tasks)

    screen.verify_stage_titles()
    screen.screenshot("/tmp/e2e_data_board.png")


def test_provider_only(client, provider_process):
    screen = HomeScreen(None, client)
    tasks_before = len(screen.get_tasks())

    screen.create_task("API only 测试", task_type="requirement")

    tasks = screen.get_tasks()
    assert len(tasks) == tasks_before + 1
