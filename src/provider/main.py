from fastapi import FastAPI

app = FastAPI(title="QTData Provider")


@app.get("/health")
async def health():
    return {"status": "ok"}
