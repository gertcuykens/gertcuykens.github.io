#!/bin/zsh
set -eEuxo pipefail

curl -fsSL https://astral.sh/uv/install.sh | sh
# wget -4O- https://astral.sh/uv/install.sh | sh
uvx ruff generate-shell-completion zsh > /usr/local/share/zsh/site-functions/_ruff
# uv self update

