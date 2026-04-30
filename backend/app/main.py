from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine
from app import models
from app.routers import recipes, upload

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Recipe Box API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(recipes.router)
app.include_router(upload.router)


@app.get("/health")
def health():
    return {"status": "ok"}
