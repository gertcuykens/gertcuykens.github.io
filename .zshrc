#!/bin/zsh

branch() {
  # git rev-parse --abbrev-ref HEAD 2>/dev/null
  b="$(git symbolic-ref --short HEAD 2> /dev/null)"
  if [[ "${b}" != "" ]]; then
    echo " ${b}"
  else
    echo ""
  fi
}

setopt histignorealldups sharehistory prompt_subst
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
PROMPT='%~%F{blue}$(branch)%F{none} %# '

source ~/.config/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh-history-substring-search/zsh-history-substring-search.zsh
fpath=(~/.config/zsh-completions/src $fpath)

bindkey -e
bindkey ${terminfo[kcuu1]} history-substring-search-up
bindkey ${terminfo[kcud1]} history-substring-search-down

zmodload zsh/complist
autoload -Uz compinit && compinit

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export CLICOLOR=1
export PYTHONNOUSERSITE=1
export VISUAL="vim"
export EDITOR="vim"

