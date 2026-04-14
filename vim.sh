#!/bin/zsh
set -eEuxo pipefail

rm -rf ~/.local/share/vim

mkdir -p ~/.local/share/vim/pack/gert/start/commentary
mkdir -p ~/.local/share/vim/pack/gert/start/airline
mkdir -p ~/.local/share/vim/pack/gert/start/fugitive
mkdir -p ~/.local/share/vim/pack/gert/start/code
mkdir -p ~/.config/vim
mkdir -p ~/.cache/vim

curl -fsSL https://github.com/tpope/vim-commentary/tarball/master | tar -xz -C ~/.local/share/vim/pack/gert/start/commentary --strip-components 1
curl -fsSL https://github.com/vim-airline/vim-airline/tarball/master | tar -xz -C ~/.local/share/vim/pack/gert/start/airline --strip-components 1
curl -fsSL https://github.com/tpope/vim-fugitive/tarball/master | tar -xz -C ~/.local/share/vim/pack/gert/start/fugitive --strip-components 1
curl -fsSL https://github.com/tomasiser/vim-code-dark/tarball/master | tar -xz -C ~/.local/share/vim/pack/gert/start/code --strip-components 1

curl -fsSLo ~/.config/vim/vimrc https://gert.ovh/.config/vim/vimrc

vim -u NONE -c "helptags commentary/doc" -c q < /dev/tty
vim -u NONE -c "helptags airline/doc" -c q < /dev/tty
vim -u NONE -c "helptags fugitive/doc" -c q < /dev/tty

