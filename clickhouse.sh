#!/bin/zsh
set -eEuxo pipefail

curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | gpg --dearmor -o /etc/apt/keyrings/clickhouse.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/clickhouse.gpg] https://packages.clickhouse.com/deb stable main" > /etc/apt/sources.list.d/clickhouse.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update
apt policy clickhouse-client
# apt install clickhouse-client
# apt install clickhouse-server
# apt install clickhouse-keeper

