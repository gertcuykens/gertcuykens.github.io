#!/bin/zsh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin

git config --global diff.tool vimdiff
git config --global mergetool.prompt false
git config --global mergetool.keepBackup false
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3
git config --global merge.ff only
git config --global pull.ff only
git config --global core.excludesfile ~/.gitignore
git config --global advice.addIgnoredFile false
git config --global branch.autoSetupMerge always
git config --global branch.autoSetupRebase always
git config --global credential.helper store
git config --global user.name "Gert Cuykens"
git config --global user.email gert.cuykens@gmail.com
git config --global init.defaultBranch main
# git config --global receive.denyCurrentBranch updateInstead

