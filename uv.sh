#!/bin/zsh
set -eEuxo pipefail

curl -fsSL https://astral.sh/uv/install.sh | sh
# wget -4O- https://astral.sh/uv/install.sh | sh
mkdir -p ~/.local/share/zsh/site-functions
# uvx ruff generate-shell-completion zsh > ~/.local/share/zsh/site-functions/_ruff
uv self update
uv tool install ruff
ruff --version

# uv tool dir
# uv tool list
# command -v ruff
# whence -av ruff

