import uuid
from datetime import datetime
from typing import Optional, List
from sqlalchemy.dialects.postgresql import UUID, JSONB, ARRAY, TIMESTAMP
from sqlalchemy import Column, text, Text
from sqlmodel import SQLModel, Field, Relationship

class User(SQLModel, table=True):
    __tablename__ = "users"

    id: uuid.UUID = Field(
        sa_column=Column(
            UUID(as_uuid=True),
            primary_key=True,
            server_default=text("gen_random_uuid()")
        )
    )

    username: str = Field(unique=True, index=True)
    display_name: Optional[str] = None

    created_at: datetime = Field(
        sa_column=Column(
            TIMESTAMP(timezone=True),
            server_default=text("NOW()")
        )
    )

    credentials: List["Credential"] = Relationship(back_populates="user")


class Credential(SQLModel, table=True):
    __tablename__ = "credentials"

    credential_id: str = Field(primary_key=True)
    user_id: uuid.UUID = Field(foreign_key="users.id", ondelete="CASCADE", index=True)
    public_key: dict = Field(sa_column=Column(JSONB, nullable=False))
    sign_count: int = Field(default=0)

    transports: Optional[List[str]] = Field(
        sa_column=Column(ARRAY(Text))
    )

    aaguid: Optional[uuid.UUID] = Field(sa_column=Column(UUID(as_uuid=True)))

    created_at: datetime = Field(
        sa_column=Column(
            TIMESTAMP(timezone=True),
            server_default=text("NOW()")
        )
    )

    last_used_at: Optional[datetime] = Field(
        sa_column=Column(TIMESTAMP(timezone=True))
    )

    user: Optional[User] = Relationship(back_populates="credentials")

# uv add alembic sqlmodel asyncpg
# alembic init -t async schema

# alembic.ini
# script_location = schema
# sqlalchemy.url = postgresql+asyncpg://root@/webauthn?host=/run/postgresql

# schema/env.py
# from sqlmodel import SQLModel
# from model import User, Credential
# target_metadata = SQLModel.metadata

# schema/script.py.mako
# import sqlmodel

# alembic revision --autogenerate -m "create webauthn tables"
# alembic upgrade head --sql

