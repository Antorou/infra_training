import uuid
import httpx
from fastapi import APIRouter, UploadFile, File, HTTPException
from pydantic import BaseModel
from app.s3 import get_s3_client, build_public_url
from app.config import settings

router = APIRouter(prefix="/api/upload", tags=["upload"])


@router.post("/file")
async def upload_file(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Only image files are accepted")
    ext = (file.filename.rsplit(".", 1)[-1] if "." in file.filename else "jpg").lower()
    key = f"recipes/{uuid.uuid4()}.{ext}"
    s3 = get_s3_client()
    s3.upload_fileobj(
        file.file,
        settings.s3_bucket,
        key,
        ExtraArgs={"ContentType": file.content_type},
    )
    return {"url": build_public_url(key)}


class UrlPayload(BaseModel):
    url: str


@router.post("/url")
async def upload_from_url(payload: UrlPayload):
    async with httpx.AsyncClient(follow_redirects=True, timeout=15) as client:
        resp = await client.get(payload.url)
    if resp.status_code != 200:
        raise HTTPException(status_code=400, detail="Failed to fetch image from URL")
    content_type = resp.headers.get("content-type", "image/jpeg").split(";")[0]
    if not content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="URL does not point to an image")
    ext = content_type.split("/")[-1]
    key = f"recipes/{uuid.uuid4()}.{ext}"
    s3 = get_s3_client()
    s3.put_object(
        Bucket=settings.s3_bucket,
        Key=key,
        Body=resp.content,
        ContentType=content_type,
    )
    return {"url": build_public_url(key)}
