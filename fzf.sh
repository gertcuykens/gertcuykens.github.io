#!/bin/zsh
set -eEuxo pipefail

curl -fsSLo fzf.tgz https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-darwin_arm64.tar.gz
# curl -fsSLo fzf.tgz https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-linux_amd64.tar.gz
tar -xzf fzf.tgz fzf
install -m 0755 fzf ~/.local/bin/fzf
# install -D -m 0755 fzf ~/.local/bin/fzf
rm -f fzf.tgz fzf

