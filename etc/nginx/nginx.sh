#!/bin/zsh
set -eEuxo pipefail

curl -fsSL https://nginx.org/keys/nginx_signing.key > /etc/apt/keyrings/nginx.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/nginx.asc] http://nginx.org/packages/debian $(. /etc/os-release && echo "$VERSION_CODENAME") nginx" > /etc/apt/sources.list.d/nginx.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update
apt policy nginx
apt install nginx
apt install nginx-module-njs

# https://github.com/tsenart/vegeta
# echo -n "username:" && openssl passwd -6 "your_password"

# apt install gnupg
# curl --fail https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /etc/apt/keyrings/nginx.gpg
# gpg --dry-run --quiet --no-keyring --import --import-options import-show /etc/apt/keyrings/nginx.gpg

# tail -f /var/log/nginx/access.log | rg --line-buffered --color=always "..." | bat --paging=never --language=log

