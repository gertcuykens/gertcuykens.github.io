#!/bin/zsh
set -eEuxo pipefail

git config --global diff.tool vimdiff
git config --global difftool.vimdiff.cmd 'vim -d "$LOCAL" "$REMOTE"'
git config --global difftool.prompt false

git config --global merge.tool vimdiff
git config --global mergetool.vimdiff.cmd 'vim -d "$LOCAL" "$REMOTE" "$MERGED"'
git config --global mergetool.vimdiff.trustExitCode true
git config --global mergetool.prompt false
git config --global mergetool.keepBackup false

git config --global merge.conflictstyle merge 
git config --global merge.ff only
git config --global pull.ff only

git config --global core.excludesfile ~/.gitignore
git config --global advice.addIgnoredFile false

git config --global init.defaultBranch main
git config --global credential.helper store

git config --global receive.denyCurrentBranch updateInstead

# git config --global user.name "Gert Cuykens"
# git config --global user.email gert.cuykens@gmail.com

###############################################################################

# git config --global branch.autoSetupMerge always
# git checkout -b feature --track origin/main 

# git config --global branch.autoSetupRebase always
# git pull --rebase

# git config --global mergetool.vimdiff.cmd 'vim -d "$LOCAL" "$BASE" "$REMOTE" "$MERGED"'

# git config --global merge.conflictstyle diff3

# LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
# curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
# tar xf lazygit.tar.gz lazygit
# install lazygit /usr/local/bin

