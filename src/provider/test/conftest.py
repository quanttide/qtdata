import os
import tempfile
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.database import Base

# ========== 模块级别：在测试文件导入前劫持数据库 ==========

# 创建临时数据库（每个 pytest 进程一个）
_tmp_dir = tempfile.mkdtemp()
TEST_DB_URL = f"sqlite:///{os.path.join(_tmp_dir, 'test.db')}"

# 测试引擎和 Session 工厂
_test_engine = create_engine(TEST_DB_URL, connect_args={"check_same_thread": False})
_TestSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=_test_engine)

# 建表
Base.metadata.create_all(bind=_test_engine)

# 关键：在 test_main.py / test_storage.py 导入前，先 patch 底层模块
import app.database
app.database.engine = _test_engine
app.database.SessionLocal = _TestSessionLocal

# 更关键：storage.py 在导入时缓存了 SessionLocal 引用，必须也 patch 它
import app.storage
app.storage.SessionLocal = _TestSessionLocal

# 强制重新初始化 app.main 的 store，让它使用被劫持后的 SessionLocal
import app.main
app.main.store = app.main.build_store()


# ========== Fixture：每个测试前清表并重灌数据 ==========
import pytest

@pytest.fixture(autouse=True)
def reset_db():
    """每个测试自动清空表并重新注入 Demo 数据"""
    from app.main import store
    from app.database import ProjectDB, TaskDB
    import app.storage

    db = app.storage.SessionLocal()
    db.query(TaskDB).delete()
    db.query(ProjectDB).delete()
    db.commit()
    db.close()

    store._init_demo_if_empty()