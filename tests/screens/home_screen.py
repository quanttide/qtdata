from screens.base_page import BasePage


class HomeScreen(BasePage):
    def __init__(self, client):
        self.client = client

    def get_projects(self):
        return self.client.get("/projects").json()

    def get_tasks(self):
        return self.client.get("/tasks").json()

    def create_project(self, name: str):
        return self.client.post("/projects", json={"id": name, "name": name, "title": name}).json()

    def create_task(self, title: str, task_type: str = "requirement"):
        return self.client.post("/tasks", json={"id": title, "title": title, "type": task_type}).json()
