import orjson
import typing
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from .api import upload
class ORJSONResponse(JSONResponse):
    media_type = "application/json"

    def render(self, content: typing.Any) -> bytes:
        return orjson.dumps(content)

app = FastAPI(default_response_class=ORJSONResponse)

origins = [
    "https://tvi.lapig.iesa.ufg.br",
    "http://127.0.0.1:8000/",
    "http://localhost:8000",
    "http://localhost:4200"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(
    upload.router, 
    prefix='/api/upload', 
    tags=['Upload Files']
    )

@app.get('/')
async def root():
    return {'message': 'ok'}



