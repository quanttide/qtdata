from fastapi import FastAPI
from fastapi_quanttide_project import ProjectRouter, TaskRouter

from app.storage import build_store

app = FastAPI(title="QTData Provider")

store = build_store()

app.include_router(ProjectRouter.build(
    create=lambda _id, p: store["projects"].setdefault(_id, p) or p,
    get=store["projects"].get,
    list_all=lambda: list(store["projects"].values()),
    update=lambda _id, p: store["projects"].update({_id: p}) or p,
    delete=lambda _id: store["projects"].pop(_id, None) is not None,
))
app.include_router(TaskRouter.build(
    create=lambda _id, t: store["tasks"].setdefault(_id, t) or t,
    get=store["tasks"].get,
    list_all=lambda: list(store["tasks"].values()),
    update=lambda _id, t: store["tasks"].update({_id: t}) or t,
    delete=lambda _id: store["tasks"].pop(_id, None) is not None,
))


@app.get("/health")
async def health():
    return {"status": "ok"}
