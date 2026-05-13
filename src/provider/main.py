from fastapi import FastAPI
from fastapi_quanttide_project import ProjectRouter, TaskRouter

app = FastAPI(title="QTData Provider")

app.include_router(ProjectRouter.build_default())
app.include_router(TaskRouter.build_default())


@app.get("/health")
async def health():
    return {"status": "ok"}
