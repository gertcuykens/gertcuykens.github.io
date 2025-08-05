#!/bin/zsh
set -eEuxo pipefail

apt install curl ca-certificates gnupg2
curl --fail https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx.gpg
# gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx.gpg

. /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/nginx.gpg] http://nginx.org/packages/debian $VERSION_CODENAME nginx" > /etc/apt/sources.list.d/nginx.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx
# apt policy nginx

apt update
apt -y install nginx

