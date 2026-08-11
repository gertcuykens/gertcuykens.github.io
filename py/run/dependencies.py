from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncEngine
from sqlmodel.ext.asyncio.session import AsyncSession

engine: AsyncEngine | None = None


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    if engine is None:
        raise RuntimeError("Database engine is not initialized")
    async with AsyncSession(engine, expire_on_commit=False) as session:
        yield session
