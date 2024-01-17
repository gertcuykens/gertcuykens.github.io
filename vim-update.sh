#!/bin/zsh
set -euxo pipefail
git -C ~/.vim/pack/gert/start/commentary pull
git -C ~/.vim/pack/gert/start/airline pull
git -C ~/.vim/pack/gert/start/fzf pull
git -C ~/.vim/pack/gert/start/fugitive pull
git -C ~/.vim/pack/gert/start/code pull
git -C ~/.vim/pack/gert/start/jedi pull

vim -u NONE -c "helptags commentary/doc" -c q
vim -u NONE -c "helptags fzf/doc" -c q
vim -u NONE -c "helptags airline/doc" -c q
vim -u NONE -c "helptags fugitive/doc" -c q
vim -u NONE -c "helptags jedi/doc" -c q

git -C ~/.fzf pull
~/.fzf/install

