#!/bin/zsh
set -eEuxo pipefail

rm -rf ~/.vim/pack/gert/start
mkdir -p ~/.vim/pack/gert/start
cd ~/.vim/pack/gert/start

git clone --depth 1 https://tpope.io/vim/commentary
git clone --depth 1 https://github.com/vim-airline/vim-airline airline
git clone --depth 1 https://tpope.io/vim/fugitive
git clone --depth 1 https://github.com/tomasiser/vim-code-dark code

vim -u NONE -c "helptags commentary/doc" -c q
vim -u NONE -c "helptags airline/doc" -c q
vim -u NONE -c "helptags fugitive/doc" -c q

cd ~
wget https://gert.ovh/.vimrc

# curl -fsSLO https://gert.ovh/.vimrc
# git -C ~/.vim/pack/gert/start/commentary pull
# git -C ~/.vim/pack/gert/start/airline pull
# git -C ~/.vim/pack/gert/start/fzf pull
# git -C ~/.vim/pack/gert/start/fugitive pull
# git -C ~/.vim/pack/gert/start/code pull

