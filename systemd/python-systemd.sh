#!/bin/zsh
docker build -t python-systemd .
docker create --name python-systemd python-systemd
# docker run -it --rm python-systemd bash
docker cp python-systemd:/root/python-systemd/dist .
docker rm python-systemd

# uv pip install python-systemd.whl
# uv run python3 -c "from systemd.journal import JournalHandler; print('OK', JournalHandler)"

# ldd ...so
# nm -u ...so

