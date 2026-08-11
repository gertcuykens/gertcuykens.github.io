from pydantic import PostgresDsn, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    database_url: PostgresDsn = PostgresDsn(
        "postgresql+asyncpg://postgres@localhost/postgres?host=/run/postgresql"
    )
    # openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 32; echo
    private_key: SecretStr = SecretStr("")
    debug: bool = False

    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", extra="ignore"
    )
