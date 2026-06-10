#!/bin/zsh
set -eEuxo pipefail

curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh
uv generate-shell-completion zsh > /usr/share/zsh/vendor-completions/_uv

uv self update
uv tool install ty
uv tool install ruff
ruff --version
mkdir -p ~/.local/share/zsh/site-functions
ruff generate-shell-completion zsh > ~/.local/share/zsh/site-functions/_ruff

# uv tool dir
# uv tool list
# command -v ruff
# whence -av ruff

