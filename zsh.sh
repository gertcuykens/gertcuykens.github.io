#!/bin/zsh
set -eEuxo pipefail

# apt install zsh zsh-doc
# chsh -s /bin/zsh root

cd ~
curl -fsSLO https://gert.ovh/.zshrc

rm -rf ~/.config/zsh-autosuggestions
rm -rf ~/.config/zsh-syntax-highlighting
rm -rf ~/.config/zsh-history-substring-search
rm -rf ~/.config/zsh-completions
rm -f ~/.config/zsh-completions/src/_zig

git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.config/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-completions.git ~/.config/zsh-completions
curl -fsSL https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig -o ~/.config/zsh-completions/src/_zig
curl -LsSf https://astral.sh/uv/install.sh | sh
uvx ruff generate-shell-completion zsh > ~/.config/zsh-completions/src/_ruff

rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin

