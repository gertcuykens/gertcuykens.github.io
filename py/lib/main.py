from typing import AsyncGenerator

from fastapi import Depends, FastAPI, Request
from fastapi.concurrency import asynccontextmanager

# from sqlmodel import SQLModel, select
from sqlmodel.ext.asyncio.session import AsyncSession


async def get_session(request: Request) -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSession(
        request.app.state.engine, expire_on_commit=False
    ) as session:
        yield session


@asynccontextmanager
async def lifespan(app: FastAPI):
    app.state.logger.debug("Starting app lifespan")
    yield
    app.state.logger.debug("Stopped app lifespan")


app = FastAPI(title="Hello World API", lifespan=lifespan)


@app.get("/")
async def hello_world(session: AsyncSession = Depends(get_session)) -> dict[str, str]:
    # todo: Use the session to query the database
    return {"message": "Hello, World!"}
