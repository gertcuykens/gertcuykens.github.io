#!/bin/zsh
set -eEuxo pipefail

curl -fsSL https://astral.sh/uv/install.sh | sh
uv self update
uv tool install ruff
ruff --version
mkdir -p ~/.local/share/zsh/site-functions
ruff generate-shell-completion zsh > ~/.local/share/zsh/site-functions/_ruff

# uv tool dir
# uv tool list
# command -v ruff
# whence -av ruff

