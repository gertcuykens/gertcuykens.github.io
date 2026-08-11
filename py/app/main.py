from fastapi import FastAPI
from fastapi.concurrency import asynccontextmanager


@asynccontextmanager
async def lifespan(app: FastAPI):
    app.state.logger.debug("Starting app lifespan")
    yield
    app.state.logger.debug("Stopped app lifespan")


app = FastAPI(title="Hello World API", lifespan=lifespan)


@app.get("/")
def hello_world() -> dict[str, str]:
    return {"message": "Hello, World!"}
