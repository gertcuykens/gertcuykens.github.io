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

# _fzf_comprun() {
#   local c=$1
#   shift
#   case "$c" in
#     cd) fzf "$@" --preview 'tree -C {} | head -500';;
#     *) fzf "$@";;
#   esac
# }

c() {
  local d="${1:-.}"
  cd $(find "$d" \( \
    -name ".git" -o \
    -name "__pycache__" -o \
    -name "node_modules" \
  \) -prune -o -type d -print | fzf --preview="tree -C {} | head -500")
}

f(){
  local d="${1:-.}"
  if [[ -f "$d" ]]; then
    echo $1 | fzf --preview="bat --color=always --style=plain --line-range=:500 {}" --bind "enter:become(vim {})"
  elif [[ -d "$d/.git" ]]; then
    git -C "$d" ls-files | fzf --preview="bat --color=always --style=plain --line-range=:500 $d/{}" --bind "enter:become(vim $d/{})"
  else
    find "$d" -type f -print | fzf --preview="bat --color=always --style=plain --line-range=:500 {}" --bind "enter:become(vim {})"
  fi
}

setopt histignorealldups sharehistory prompt_subst
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
PROMPT=' %~%F{blue}$(branch)%F{none} %# '

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
export VISUAL="vim"
export EDITOR="vim"
export PYTHONNOUSERSITE=1
export PYTHONUNBUFFERED=1
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
export BAT_STYLE="plain"
export LANG=en_US.UTF-8
export NNN_PLUG='p:preview-tui;f:fzcd'
export NNN_FIFO='/tmp/nnn.fifo'
# export NNN_FCOLORS=''
# export FZF_DEFAULT_COMMAND=''
# export FZF_CTRL_T_COMMAND=''
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_ALT_C_COMMAND='find . \( \
    -name ".git" -o \
    -name "__pycache__" -o \
    -name "node_modules" \
  \) -prune -o -type d -print'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -500'"

[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && export path=("${HOME}/.fzf/bin" $path)

# undo => Ctrl-U
# stty -ixon => disable Ctrl-S / Ctrl-Q

