#!/bin/zsh
set -eEuxo pipefail

useradd -m -s /bin/zsh <username>
usermod -aG docker <username>

# chsh -s /bin/zsh <username>

