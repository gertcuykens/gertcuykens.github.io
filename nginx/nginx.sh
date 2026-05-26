#!/bin/zsh
set -eEuxo pipefail

apt install ca-certificates gnupg

# curl --fail https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /etc/apt/keyrings/nginx.gpg
# wget -4O- https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /etc/apt/keyrings/nginx.gpg
# gpg --dry-run --quiet --no-keyring --import --import-options import-show /etc/apt/keyrings/nginx.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/nginx.gpg] http://nginx.org/packages/debian $(. /etc/os-release && echo "$VERSION_CODENAME") nginx" > /etc/apt/sources.list.d/nginx.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update
apt policy nginx
apt install nginx
apt install nginx-module-njs

# https://github.com/tsenart/vegeta

