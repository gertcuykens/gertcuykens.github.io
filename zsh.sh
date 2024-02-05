#!/bin/zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.config/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.config/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-completions.git ~/.config/zsh-completions
curl https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig -s -o ~/.config/zsh-completions/src/_zig
chsh -s /bin/zsh
curl -fLO https://gert.ovh/.zshrc

