from run.settings import Settings


def test_settings_defaults():
    s = Settings()
    assert (
        str(s.database_url)
        == "postgresql+asyncpg://postgres@localhost/postgres?host=/run/postgresql"
    )
    assert s.secret.get_secret_value() == ""
    assert s.debug is False


def test_settings_override(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "postgresql+asyncpg://user:pass@localhost/db")
    monkeypatch.setenv("SECRET", "supersecret")
    monkeypatch.setenv("DEBUG", "true")
    s = Settings()
    assert "localhost" in str(s.database_url)
    assert s.secret.get_secret_value() == "supersecret"
    assert s.debug is True
