#!/bin/zsh
set -eEuxo pipefail

useradd -m -s /bin/zsh <username>
usermod -aG docker <username>
usermod -aG systemd-journal <username>
userdel -r <username>
chsh -s /bin/zsh <username>
getent passwd <username>
getent group <group> || groupadd -r <group>

