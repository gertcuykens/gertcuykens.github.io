#!/bin/zsh
set -eEuxo pipefail

# apt install zsh vim git bzip2 universal-ctags
# chsh -s /bin/zsh root

# infocmp -x xterm-ghostty | ssh root@... -- tic -x -

rm -rf ~/.local/share/fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
# curl -fsSLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

wget https://github.com/sharkdp/fd/releases/download/v10.3.0/fd_10.3.0_amd64.deb
wget -i fd_10.3.0_amd64.deb

wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
dpkg -i ripgrep_14.1.1-1_amd64.deb

wget https://github.com/sharkdp/bat/releases/download/v0.26.0/bat_0.26.0_amd64.deb
dpkg -i bat_0.26.0_amd64.deb

curl -fsSL https://astral.sh/uv/install.sh | sh

curl -fsSL https://rclone.org/install.sh | bash

curl -fsSL https://github.com/restic/restic/releases/download/v0.17.3/restic_0.17.3_linux_arm64.bz2 -o /usr/local/bin/restic.bz2
bunzip2 /usr/local/bin/restic.bz2
restic generate --zsh-completion /usr/local/share/zsh/site-functions/_restic

rm -rf ~/.config/zsh-autosuggestions
rm -rf ~/.config/zsh-syntax-highlighting
rm -rf ~/.config/zsh-history-substring-search
rm -rf ~/.config/zsh-completions

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh-syntax-highlighting
git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search.git ~/.config/zsh-history-substring-search
git clone --depth 1 https://github.com/zsh-users/zsh-completions.git ~/.config/zsh-completions

curl -fsSLo /usr/local/share/zsh/site-functions/_zig https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig
# curl -fsSLo /usr/local/share/zsh/site-functions/_cht https://cheat.sh/:zsh
uvx ruff generate-shell-completion zsh > /usr/local/share/zsh/site-functions/_ruff

curl -fsSLo ~/.zshrc https://gert.ovh/.zshrc

# typeset -U fpath
# type python3
# whence -av python3
# command -v python3

