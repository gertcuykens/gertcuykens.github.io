FROM debian:bookworm-slim
USER root
WORKDIR /root

RUN apt update && apt upgrade
RUN apt install -y ca-certificates && update-ca-certificates
RUN apt install -y build-essential pkg-config libsystemd-dev curl git python3-pip python3-dev
RUN apt autoremove --purge
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/* /var/tmp/* 

RUN python3 -m pip config set global.break-system-packages true
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install build

RUN git clone https://github.com/systemd/python-systemd.git
RUN cd python-systemd; python3 -m build --wheel

# RUN python3 -m pip install --no-cache-dir uv
# RUN uv build --wheel --package systemd-python

