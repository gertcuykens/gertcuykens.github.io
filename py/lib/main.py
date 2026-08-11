from fastapi import Depends, FastAPI

# from sqlmodel import SQLModel, select
from sqlmodel.ext.asyncio.session import AsyncSession

from run.main import get_session, lifespan

app = FastAPI(title="Hello World API", lifespan=lifespan)


@app.get("/")
async def hello_world(session: AsyncSession = Depends(get_session)) -> dict[str, str]:
    # todo: Use the session to query the database
    return {"message": "Hello, World!"}
