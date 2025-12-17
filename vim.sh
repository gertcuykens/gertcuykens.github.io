#!/bin/zsh
set -eEuxo pipefail

rm -rf ~/.local/share/vim/
mkdir -p ~/.local/share/vim/pack/gert/start
cd ~/.local/share/vim/pack/gert/start

git clone --depth 1 https://tpope.io/vim/commentary
git clone --depth 1 https://github.com/vim-airline/vim-airline airline
git clone --depth 1 https://tpope.io/vim/fugitive
git clone --depth 1 https://github.com/tomasiser/vim-code-dark code

vim -u NONE -c "helptags commentary/doc" -c q
vim -u NONE -c "helptags airline/doc" -c q
vim -u NONE -c "helptags fugitive/doc" -c q

rm -rf ~/.config/vim
mkdir -p ~/.config/vim
cd ~/.config/vim
curl -fsSLO https://gert.ovh/.config/vim/vimrc

