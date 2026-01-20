#!/bin/zsh
set -eEuxo pipefail

rm -rf ~/.local/share/vim
mkdir -p ~/.local/share/vim/pack/gert/start
cd ~/.local/share/vim/pack/gert/start

git clone --depth 1 https://tpope.io/vim/commentary
git clone --depth 1 https://github.com/vim-airline/vim-airline airline
git clone --depth 1 https://tpope.io/vim/fugitive
git clone --depth 1 https://github.com/tomasiser/vim-code-dark code

vim -u NONE -c "helptags commentary/doc" -c q < /dev/tty
vim -u NONE -c "helptags airline/doc" -c q < /dev/tty
vim -u NONE -c "helptags fugitive/doc" -c q < /dev/tty

cd ~
mkdir -p ~/.config/vim
curl -fsSLo ~/.config/vim/vimrc https://gert.ovh/.config/vim/vimrc

