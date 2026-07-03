#!/bin/zsh
set -eEuxo pipefail

curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' > /etc/apt/keyrings/clickhouse.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/clickhouse.asc] https://packages.clickhouse.com/deb stable main" > /etc/apt/sources.list.d/clickhouse.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update
apt policy clickhouse-client
# apt install clickhouse-client
# apt install clickhouse-server
# apt install clickhouse-keeper

# echo 'CLICKHOUSE_WATCHDOG_ENABLE=0' > /etc/default/clickhouse-server

# curl https://clickhouse.com/ | CLICKHOUSE_ONLY=1 sh
# sudo xattr -d com.apple.quarantine /opt/homebrew/bin/clickhouse

