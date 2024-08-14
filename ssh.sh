#!/bin/zsh
set -eEuxo pipefail

ssh-keygen -t ed25519 -C "root@a"
# ssh-keygen -y -f id_a > id_a.pub
# ssh-copy-id -i ~/.ssh/id_ed25519 root@a
# vim .ssh/authorized_keys
# ssh-keygen -f "/root/.ssh/known_hosts" -R "10.201.10.193"
# tunnel
# add auth
# add scan

