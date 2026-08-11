import logging

from fastapi import APIRouter, Depends, Request

# from sqlmodel import SQLModel, select
from sqlmodel.ext.asyncio.session import AsyncSession

from run.dependencies import get_session

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/")
async def hello_world(
    request: Request, session: AsyncSession = Depends(get_session)
) -> dict[str, str]:
    logger.debug(request.headers)
    # todo: Use the session to query the database
    return {"message": "Hello, World!"}
