class BasePage:
    def __init__(self, driver):
        self.driver = driver

    def find_by_key(self, key: str):
        return self.driver.find_element("flutter", key)

    def find_by_text(self, text: str):
        return self.driver.find_element("flutter", text)

    def tap_by_key(self, key: str):
        self.find_by_key(key).click()

    def get_text(self, key: str):
        return self.find_by_key(key).text

    def screenshot(self, path: str):
        self.driver.save_screenshot(path)
