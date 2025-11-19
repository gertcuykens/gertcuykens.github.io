#!/bin/zsh
set -eEuxo pipefail

# apt install curl ca-certificates
# install -d /usr/share/postgresql-common/pgdg
# curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

wget -4O /etc/apt/keyrings/postgresql.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/postgresql.asc] https://apt.postgresql.org/pub/repos/apt $(. /etc/os-release && echo "$VERSION_CODENAME")-pgdg main" > /etc/apt/sources.list.d/postgresql.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update
apt policy postgresql
apt install postgresql

