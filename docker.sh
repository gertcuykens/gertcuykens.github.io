#!/bin/zsh
set -euxo pipefail

curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

apt update
apt install docker-ce docker-ce-cli containerd.io

echo '{"log-driver": "journald"}' > /etc/docker/daemon.json

