import asyncio
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


async def main() -> int:
    import uvicorn
    from sqlalchemy.ext.asyncio import create_async_engine
    from sqlmodel import SQLModel

    from lib.main import app
    from run.settings import Settings

    settings = Settings()
    logger.level = logging.DEBUG if settings.debug else logging.INFO
    app.state.logger = logger
    app.state.engine = create_async_engine(str(settings.database_url), echo=False)
    async with app.state.engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)
    uvicorn.run(app, loop="uvloop", http="httptools")
    await app.state.engine.dispose()
    return 0


def app() -> None:
    raise SystemExit(asyncio.run(main()))


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
