#!/bin/zsh
set -eEuxo pipefail

useradd -m -s /bin/zsh <username>
usermod -aG docker <username>
usermod -aG systemd-journal <username>

# chsh -s /bin/zsh <username>

