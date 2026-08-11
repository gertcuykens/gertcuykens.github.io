from datetime import datetime
from uuid import UUID, uuid7

from sqlmodel import (
    ARRAY,
    TIMESTAMP,
    Column,
    Field,
    LargeBinary,
    Relationship,
    SQLModel,
    Text,
    text,
)
from sqlmodel import (
    UUID as SQLUUID,
)


class User(SQLModel, table=True):
    __tablename__ = "users"

    id: UUID = Field(
        default_factory=uuid7,
        sa_column=Column(
            SQLUUID(as_uuid=True), primary_key=True, server_default=text("uuidv7()")
        ),
    )

    name: str = Field(unique=True, index=True)
    display_name: str | None = Field(default=None, index=True)

    created_at: datetime | None = Field(
        default=None,
        sa_column=Column(TIMESTAMP(timezone=True), server_default=text("NOW()")),
    )

    credentials: list["Credential"] = Relationship(
        back_populates="user", sa_relationship_kwargs={"lazy": "selectin"}
    )


class Credential(SQLModel, table=True):
    __tablename__ = "credentials"

    id: str = Field(primary_key=True)
    user_id: UUID = Field(foreign_key="users.id", ondelete="CASCADE", index=True)
    public_key: bytes = Field(sa_column=Column(LargeBinary, nullable=False))
    sign_count: int = Field(default=0)
    transports: list[str] | None = Field(default=None, sa_column=Column(ARRAY(Text)))
    aaguid: UUID | None = Field(default=None, sa_column=Column(SQLUUID(as_uuid=True)))

    created_at: datetime | None = Field(
        default=None,
        sa_column=Column(TIMESTAMP(timezone=True), server_default=text("NOW()")),
    )

    last_used_at: datetime | None = Field(
        default=None, sa_column=Column(TIMESTAMP(timezone=True))
    )

    user: User | None = Relationship(
        back_populates="credentials", sa_relationship_kwargs={"lazy": "joined"}
    )
