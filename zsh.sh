#!/bin/zsh
set -eEuxo pipefail

rm -rf ~/.local/share/zsh/syntax-highlighting
rm -rf ~/.local/share/zsh/autosuggestions
rm -rf ~/.local/share/zsh/history-substring-search
rm -rf ~/.local/share/zsh/oh-my-zsh
rm -rf ~/.local/share/zsh/site-functions

mkdir -p ~/.cache/zsh
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/zsh/syntax-highlighting
mkdir -p ~/.local/share/zsh/autosuggestions
mkdir -p ~/.local/share/zsh/history-substring-search
mkdir -p ~/.local/share/zsh/oh-my-zsh
mkdir -p ~/.local/share/zsh/site-functions
mkdir -p ~/.local/state/zsh

curl -fsSL https://github.com/zsh-users/zsh-syntax-highlighting/tarball/master | tar -xz -C ~/.local/share/zsh/syntax-highlighting --strip-components 1
curl -fsSL https://github.com/zsh-users/zsh-autosuggestions/tarball/master | tar -xz -C ~/.local/share/zsh/autosuggestions --strip-components 1
curl -fsSL https://github.com/zsh-users/zsh-history-substring-search/tarball/master | tar -xz -C ~/.local/share/zsh/history-substring-search --strip-components 1
curl -fsSL https://github.com/ohmyzsh/ohmyzsh/tarball/master | tar -xz -C ~/.local/share/zsh/oh-my-zsh --strip-components 1

curl -fsSLo ~/.local/share/zsh/key-bindings.zsh https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh
curl -fsSLo ~/.local/share/zsh/completion.zsh https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/completion.zsh

curl -fsSL https://github.com/zsh-users/zsh-completions/tarball/master | tar -xz -C ~/.local/share/zsh/site-functions --strip-components 2 "*/src/*"

curl -fsSLo ~/.local/bin/env https://gert.ovh/.local/bin/env
curl -fsSLo ~/.zshrc https://gert.ovh/.zshrc

# .zshenv before login basic environment exports for every zsh process
# .zprofile after login
# .zshrc interactive shell

# git archive --remote=https://github.com/zsh-users/zsh-completions.git HEAD:src | tar -x
# ... --strip-components=2 --wildcards "*/src/*"

