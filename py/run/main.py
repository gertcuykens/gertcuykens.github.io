import asyncio
import logging

import uvicorn
from fastapi import FastAPI
from fastapi.concurrency import asynccontextmanager
from sqlalchemy.ext.asyncio import create_async_engine
from sqlmodel import SQLModel
from starlette.middleware.sessions import SessionMiddleware

from lib.main import router
from run import dependencies
from run.settings import Settings

logger = logging.getLogger(__name__)


def configure_loggers(level: int) -> None:
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(name)s: %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)

    root_logger = logging.getLogger()
    root_logger.handlers = [handler]
    root_logger.setLevel(level)

    for existing_logger in logging.root.manager.loggerDict.values():
        if isinstance(existing_logger, logging.Logger):
            existing_logger.handlers.clear()
            existing_logger.setLevel(level)
            existing_logger.propagate = True

    logging.getLogger("sqlalchemy.engine").setLevel(logging.WARNING)


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.debug("Starting app lifespan")
    yield
    logger.debug("Stopped app lifespan")


app = FastAPI(title="Hello World API", lifespan=lifespan)
app.include_router(router)


async def main() -> int:
    settings = Settings()
    log_level = logging.DEBUG if settings.debug else logging.INFO
    configure_loggers(log_level)
    logger.debug("Starting app with settings: %s", settings)
    engine = create_async_engine(str(settings.database_url), echo=False)
    dependencies.engine = engine
    app.add_middleware(
        SessionMiddleware, secret_key=settings.secret.get_secret_value(), max_age=300
    )
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)
    config = uvicorn.Config(app, loop="uvloop", http="httptools")
    server = uvicorn.Server(config)
    await server.serve()
    await engine.dispose()
    return 0


def exe() -> None:
    raise SystemExit(asyncio.run(main()))


if __name__ == "__main__":
    raise SystemExit(asyncio.run(main()))
