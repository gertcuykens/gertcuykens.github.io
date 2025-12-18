#!/bin/zsh
set -eEuxo pipefail

# https://wiki.debian.org/SourcesList
# /etc/apt/sources.list.d/debian.sources
# Types: deb deb-src
# URIs: http://deb.debian.org/debian
# Suites: trixie trixie-updates trixie-security
# Components: main non-free-firmware
# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# apt update
# apt upgrade
# apt install zsh vim curl git universal-ctags gnupg bzip2 ca-certificates && update-ca-certificates
# apt autoremove --purge
# apt clean

# infocmp -x xterm-ghostty | ssh root@... -- tic -x -

# chsh -s /bin/zsh root

# mkdir -p ~/.cache/zsh
# mkdir -p ~/.config/zsh
# mkdir -p ~/.local/bin
# mkdir -p ~/.local/share/zsh/site-functions
# mkdir -p ~/.local/state/zsh

rm -rf ~/.local/share/fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fsSLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

curl -fsSLO https://github.com/sharkdp/fd/releases/download/v10.3.0/fd_10.3.0_amd64.deb
dpkg -i fd.deb

curl -fsSLO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb
dpkg -i ripgrep.deb

curl -fsSLO https://github.com/sharkdp/bat/releases/download/v0.26.0/bat_0.26.0_amd64.deb
dpkg -i bat.deb

curl -fsSL https://rclone.org/install.sh | bash

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.local/share/zsh/autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/share/zsh/syntax-highlighting
# git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search.git ~/.local/share/zsh/history-substring-search

git clone --depth 1 https://github.com/zsh-users/zsh-completions.git
cp zsh-completions/src/* ~/.local/share/zsh/site-functions
rm -rf zsh-completions

curl -fsSLo ~/.local/share/zsh/site-functions/_zig https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig

# curl -fsSLo /usr/local/share/zsh/site-functions/_cht https://cheat.sh/:zsh

curl -fsSLo ~/.zshrc https://gert.ovh/.zshrc

# typeset -U fpath
# type python3
# whence -av python3
# command -v python3

# rm -rf /var/lib/apt/lists/*
# rm -rf /tmp/*
# rm -rf /var/tmp/*

# .zshenv before login basic environment exports for every zsh process
# .zprofile after login
# .zshrc interactive shell

