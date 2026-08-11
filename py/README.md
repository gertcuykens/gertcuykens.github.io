# SETUP
uv tool install ty@latest
uv tool install ruff@latest
uv python install

# ENV
uv venv --python ~/.local/bin/python3.14
uv sync --upgrade --all-groups --all-extras --reinstall

# RUN
uv run --group tests pytest --cov=run --cov-report=html
uv run --group tests pytest tests/test_settings.py::test_settings_defaults
uv run uvicorn app.main:app --loop uvloop --http httptools
uv pip install -e ".[run]"
uv run gert

# TODO: WebTranspor
