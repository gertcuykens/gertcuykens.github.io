import logging

from fastapi import APIRouter, Depends, Request
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from lib.model import User
from run.dependencies import get_session

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/")
async def hello_world(
    request: Request, session: AsyncSession = Depends(get_session)
) -> dict[str, str]:
    logger.debug(request.headers)
    user_name = "hello-world"
    result = await session.exec(select(User).where(User.name == user_name))
    user = result.one_or_none()

    if user is None:
        user = User(name=user_name, display_name="Hello World")
        session.add(user)
        await session.commit()
        await session.refresh(user)
    elif user.display_name != "Hello World":
        user.display_name = "Hello World"
        session.add(user)
        await session.commit()
        await session.refresh(user)

    return {"message": f"{user.display_name or user.name}!"}
