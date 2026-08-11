from fastapi import Depends

# from sqlmodel import SQLModel, select
from sqlmodel.ext.asyncio.session import AsyncSession

from run.main import app, get_session


@app.get("/")
async def hello_world(session: AsyncSession = Depends(get_session)) -> dict[str, str]:
    # todo: Use the session to query the database
    return {"message": "Hello, World!"}
