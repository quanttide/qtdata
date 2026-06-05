from app.storage import build_store


def test_demo_projects():
    store = build_store()
    assert len(store["projects"]) == 3
    assert "p1" in store["projects"]
    assert store["projects"]["p1"].title == "数据项目 1"


def test_demo_tasks():
    store = build_store()
    assert len(store["tasks"]) == 15
    assert "r1" in store["tasks"]
    assert store["tasks"]["r1"].type == "requirement"

# # 内存隔离
# def test_store_isolation():
#     store = build_store()
#     store["tasks"].pop("r1")
#     assert "r1" not in store["tasks"]
#     fresh = build_store()
#     assert "r1" in fresh["tasks"]

def test_store_persistence():
    """
    原 test_store_isolation 的语义升级。
    持久化架构下，删除会真实写入数据库，所有实例共享同一状态。
    """
    store = build_store()
    # 确保 demo 数据存在
    assert "r1" in store["tasks"]
    
    # 删除 r1
    store["tasks"].pop("r1")
    assert "r1" not in store["tasks"]
    
    # 重新 build_store，读取的是同一个持久化数据库
    fresh = build_store()
    # 持久化生效：删除被保留，fresh 也看不到 r1
    assert "r1" not in fresh["tasks"]