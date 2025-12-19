#!/bin/zsh
set -eEuxo pipefail

curl -fsSLo /etc/apt/keyrings/docker.asc https://download.docker.com/linux/debian/gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

# echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx

apt update
apt policy docker-ce
apt install docker-ce docker-ce-cli containerd.io

echo '{"log-driver": "journald"}' > /etc/docker/daemon.json

# function psql() {
#     if [ -t 0 ]; then
#         docker run -it --rm -v /run/postgresql:/run/postgresql postgres psql "$@"
#     else
#         docker run -i --rm -v /run/postgresql:/run/postgresql postgres psql "$@"
#     fi
# }

