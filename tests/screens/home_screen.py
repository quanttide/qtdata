from utils.driver import FlutterDriver
from utils.screenshot import capture


class HomeScreen:
    STAGE_TITLES = ["需求探索", "约定启动", "执行监控", "验收交付"]

    def __init__(self, client, driver: FlutterDriver | None = None):
        self.client = client
        self.driver = driver

    def launch(self):
        if self.driver:
            self.driver.start()

    def close(self):
        if self.driver:
            self.driver.stop()

    def screenshot(self, name: str):
        return capture(name, window_title="量潮数据")

    def get_projects(self):
        return self.client.get("/projects").json()

    def get_tasks(self):
        return self.client.get("/tasks").json()

    def create_project(self, name: str):
        return self.client.post("/projects", json={"id": name, "name": name, "title": name}).json()

    def create_task(self, title: str, task_type: str = "requirement"):
        return self.client.post(
            "/tasks",
            json={"id": title, "title": title, "type": task_type},
        ).json()
