#!/bin/zsh
set -eEuxo pipefail

mkdir -p ~/.cache/zsh
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/zsh/site-functions
mkdir -p ~/.local/state/zsh

###############################################################################
# source                                                                      #
###############################################################################

rm -rf ~/.local/share/zsh/autosuggestions
rm -rf ~/.local/share/zsh/syntax-highlighting
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.local/share/zsh/autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.local/share/zsh/syntax-highlighting
curl -fsSLo ~/.local/share/zsh/key-bindings.zsh https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh
curl -fsSLo ~/.local/share/zsh/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/completion.zsh

###############################################################################
# site-functions                                                              #
###############################################################################

rm -rf ~/.local/share/zsh/site-functions
mkdir -p ~/.local/share/zsh/site-functions

git clone --depth 1 https://github.com/zsh-users/zsh-completions.git ~/zsh-completions
cp ~/zsh-completions/src/* ~/.local/share/zsh/site-functions
rm -rf ~/zsh-completions

curl -fsSLo ~/.local/share/zsh/site-functions/_zig https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig

###############################################################################

curl -fsSLo ~/.local/bin/env https://gert.ovh/.local/bin/env
curl -fsSLo ~/.zshrc https://gert.ovh/.zshrc

# .zshenv before login basic environment exports for every zsh process
# .zprofile after login
# .zshrc interactive shell

