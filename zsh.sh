#!/bin/zsh
set -eEuxo pipefail

# apt install zsh bzip2
# chsh -s /bin/zsh root

curl -fsSL https://astral.sh/uv/install.sh | sh
curl -fsSL https://rclone.org/install.sh | bash

curl -fsSL https://github.com/sharkdp/bat/releases/download/v0.25.0/bat_0.25.0_amd64.deb -o ~/bat.deb
dpkg -i ~/bat.deb

curl -fsSL https://github.com/restic/restic/releases/download/v0.17.3/restic_0.17.3_linux_arm64.bz2 -o /usr/local/bin/restic.bz2
bunzip2 /usr/local/bin/restic.bz2

rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin

rm -rf ~/.config/zsh-autosuggestions
rm -rf ~/.config/zsh-syntax-highlighting
rm -rf ~/.config/zsh-history-substring-search
rm -rf ~/.config/zsh-completions

git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.config/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-completions.git ~/.config/zsh-completions

curl -fsSL https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig -o /usr/local/share/zsh/site-functions/_zig
curl -fsSL https://cheat.sh/:zsh -o /usr/local/share/zsh/site-functions/_cht
uvx ruff generate-shell-completion zsh > /usr/local/share/zsh/site-functions/_ruff
restic generate --zsh-completion /usr/local/share/zsh/site-functions/_restic

curl -fsSL https://gert.ovh/.zshrc -o ~/.zshrc

