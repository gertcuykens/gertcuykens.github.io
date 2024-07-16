#!/bin/zsh
set -eEuxo pipefail

# apt install vim vim-doc

rm -rf ~/.local/share/fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fsSLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

rm -rf ~/.vim/pack/gert/start
mkdir -p ~/.vim/pack/gert/start
cd ~/.vim/pack/gert/start

git clone --depth 1 https://tpope.io/vim/commentary
git clone --depth 1 https://github.com/vim-airline/vim-airline airline
git clone --depth 1 https://github.com/junegunn/fzf.vim fzf
git clone --depth 1 https://tpope.io/vim/fugitive
git clone --depth 1 https://github.com/tomasiser/vim-code-dark code
# git clone --depth 1 --recurse-submodules https://github.com/davidhalter/jedi-vim jedi

vim -u NONE -c "helptags commentary/doc" -c q
vim -u NONE -c "helptags fzf/doc" -c q
vim -u NONE -c "helptags airline/doc" -c q
vim -u NONE -c "helptags fugitive/doc" -c q
# vim -u NONE -c "helptags jedi/doc" -c q

rm -rf ~/.fzf
cd ~
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

curl -fsSLO https://gert.ovh/.vimrc

