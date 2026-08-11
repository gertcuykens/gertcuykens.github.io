# SETUP
uv tool install ty@latest
uv tool install ruff@latest
uv python install

# ENV
uv venv --python ~/.local/bin/python3.14
uv sync --upgrade --all-groups --all-extras --reinstall

# RUN
uv run --group tests pytest --cov=lib --cov-report=html
uv run --group tests pytest tests/test_settings.py::test_settings_defaults
uv run app

# PKG
uv build
uv pip install -e ".[run]

# TODO: WebTranspor, uv build

# SQL
alembic init -t async schema

alembic.ini
script_location = schema
sqlalchemy.url = postgresql+asyncpg://...@/...?host=/run/postgresql

schema/env.py
from sqlmodel import SQLModel
from lib.model import User, Credential
target_metadata = SQLModel.metadata

schema/script.py.mako
import sqlmodel

alembic revision --autogenerate -m "create tables"
alembic upgrade head --sql