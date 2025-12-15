#!/bin/zsh
set -eEuxo pipefail

wget -4O- 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | gpg --dearmor -o /etc/apt/keyrings/clickhouse.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/clickhouse.gpg] https://packages.clickhouse.com/deb stable main" > /etc/apt/sources.list.d/clickhouse.list

apt update
apt policy clickhouse-client
# apt install clickhouse-client
# apt install clickhouse-server
# apt install clickhouse-keeper

# apt install gnupg ca-certificates && update-ca-certificates
# ENV LANG=C.UTF-8
# ENV LC_ALL=C.UTF-8
# RUN apt update && apt upgrade -y
# RUN apt install -y python3-psutil postgresql-plpython3-17
# RUN apt autoremove -y --purge && apt clean -y \
#     && rm -rf /var/lib/apt/lists/* \
#     && rm -rf /tmp/* \
#     && rm -rf /var/tmp/*
# install -d /usr/share/postgresql-common/pgdg
# $(. /etc/os-release && echo "$VERSION_CODENAME")
# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

