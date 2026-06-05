from datetime import datetime, timezone
from types import SimpleNamespace
from typing import TypeVar, Generic, Type, Any
from sqlalchemy.orm import Session
from app.database import SessionLocal, init_db, Base, ProjectDB, TaskDB

ModelType = TypeVar("ModelType", bound=Base)

class BaseRepo(Generic[ModelType]):
    def __init__(self, db: Session, model: Type[ModelType]):
        self.db = db
        self.model = model

    def get(self, _id: str) -> ModelType | None:
        return self.db.query(self.model).filter(self.model.id == _id).first()

    def list_all(self) -> list[ModelType]:
        return list(self.db.query(self.model).all())

    def setdefault(self, _id: str, p: Any) -> Any:
        existing = self.get(_id)
        if existing is not None:
            return self._to_obj(existing)
        
        kwargs = {}
        for col in self._get_columns():
            if col == "id":
                continue
            val = getattr(p, col, None)
            if val is None and col in ("created_at", "updated_at"):
                val = datetime.now(timezone.utc)
            kwargs[col] = val
        
        instance = self.model(id=_id, **kwargs)
        self.db.add(instance)
        self.db.commit()
        self.db.refresh(instance)
        return p

    def update(self, update_dict: dict) -> Any:
        if not update_dict:
            return None
        _id, p = next(iter(update_dict.items()))
        instance = self.get(_id)
        if instance is None:
            return p
        for col in self._get_columns():
            if col == "id":
                continue
            val = getattr(p, col, None)
            if val is not None:
                setattr(instance, col, val)
        if "updated_at" in self._get_columns():
            instance.updated_at = datetime.now(timezone.utc)
        self.db.commit()
        self.db.refresh(instance)
        return p

    def pop(self, _id: str, default: Any = None) -> bool:
        instance = self.get(_id)
        if instance is None:
            return False
        self.db.delete(instance)
        self.db.commit()
        return True

    def _get_columns(self) -> list[str]:
        return [c.name for c in self.model.__table__.columns]

    def _to_obj(self, row: ModelType) -> Any:
        from types import SimpleNamespace
        return SimpleNamespace(**{c: getattr(row, c) for c in self._get_columns()})


class ProjectRepo(BaseRepo[ProjectDB]):
    def __init__(self, db: Session):
        super().__init__(db, ProjectDB)

    def _to_obj(self, row: ProjectDB):
        """返回 Pydantic 模型，让 Router 的 _apply 能正常工作"""
        from quanttide_project import Project
        return Project(
            id=row.id,
            name=row.name or "",
            title=row.title or "",
            created_by=row.created_by,
            created_at=row.created_at,
            updated_at=row.updated_at,
        )


class TaskRepo(BaseRepo[TaskDB]):
    def __init__(self, db: Session):
        super().__init__(db, TaskDB)

    def _to_obj(self, row: TaskDB):
        from quanttide_project import Task
        return Task(
            id=row.id,
            title=row.title or "",
            description=row.description,
            type=row.type or "",
            status=row.status,
        )


# ========== 兼容层：让 main.py 的 lambda 不用改 ==========
class _CompatProxy:
    def __init__(self, key: str):
        self.key = key

    def setdefault(self, _id: str, p: Any) -> Any:
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            return repo.setdefault(_id, p)
        finally:
            db.close()

    def get(self, _id: str) -> Any | None:
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            result = repo.get(_id)
            return repo._to_obj(result) if result else None
        finally:
            db.close()

    def values(self) -> list[Any]:
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            rows = repo.list_all()
            return [repo._to_obj(r) for r in rows]
        finally:
            db.close()

    def update(self, update_dict: dict) -> Any:
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            return repo.update(update_dict)
        finally:
            db.close()

    def pop(self, _id: str, default: Any = None) -> bool:
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            return repo.pop(_id)
        finally:
            db.close()
    def __len__(self):
            db = SessionLocal()
            try:
                repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
                return len(repo.list_all())
            finally:
                db.close()

    def __contains__(self, _id):
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            return repo.get(_id) is not None
        finally:
            db.close()

    def __getitem__(self, _id):
        db = SessionLocal()
        try:
            repo = ProjectRepo(db) if self.key == "projects" else TaskRepo(db)
            result = repo.get(_id)
            if result is None:
                raise KeyError(_id)
            return repo._to_obj(result)
        finally:
            db.close()

class DBStore:
     def __init__(self):
        init_db()
        self._projects = _CompatProxy("projects")
        self._tasks = _CompatProxy("tasks")  

     def _init_demo_if_empty(self):
        if not self._projects.values():
            for i in range(1, 4):
                self._projects.setdefault(
                    f"p{i}",
                    SimpleNamespace(
                        id=f"p{i}",
                        name=f"项目{i}",
                        title=f"数据项目 {i}",
                        created_by="system",
                        created_at=datetime.now(timezone.utc),
                        updated_at=datetime.now(timezone.utc),
                    ),
                )
        
        if not self._tasks.values():
            task_types = [
                "requirement", "agreement", "execution", "acceptance",
                "requirement", "agreement", "execution", "acceptance",
                "requirement", "agreement", "execution", "acceptance",
                "requirement", "agreement", "execution",  # 第15个
            ]
            for i in range(1, 16):
                tid = "r1" if i == 1 else f"t{i}"
                self._tasks.setdefault(
                    tid,
                    SimpleNamespace(
                        id=tid,
                        title=f"任务{i}",
                        description=f"任务{i}描述",
                        type=task_types[i - 1],
                        status="pending",
                    ),
                )

     def __getitem__(self, key: str):
        if key == "projects":
            return self._projects
        if key == "tasks":
            return self._tasks
        raise KeyError(key)

def build_store():
    return DBStore()