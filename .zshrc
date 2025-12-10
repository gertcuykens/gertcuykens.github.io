#!/bin/zsh

_b() {
  # git rev-parse --abbrev-ref HEAD 2>/dev/null
  local b="$(git symbolic-ref --short HEAD 2>/dev/null)"
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

f() {
  local d="${1:-.}"
  [[ "$d" != */ ]] && d="$d/"
  local p=$( (echo "$d"; fd . "$d" --full-path --follow --hidden \
    --exclude .git \
    --exclude .venv \
    --exclude __pycache__ \
    --exclude node_modules) \
    | fzf --no-sort --info=inline --ansi --prompt "$d" \
      --preview='
        if [[ -d {} ]]; then
          tree -N -C {} -I ".git|.venv|__pycache__|node_modules" | head -500
        else
          bat --color=always --style=plain --line-range=:500 {}
        fi') 
  if [[ -n $p ]]; then
    if [[ -d $p ]]; then
      cd "$p"
    elif [[ $p == *.png ]]; then
      png "$p"
    else
      vim "$p"
    fi
  fi
}

fr() {
  : | fzf \
    --bind "start:reload:rg --line-number --column --no-heading --color=always --smart-case \"${1}\" || true" \
    --bind 'change:reload:rg --line-number --column --no-heading --color=always --smart-case {q} || true' \
    --bind 'enter:become(vim {1} +{2})' \
    --delimiter ':' \
    --ansi --disabled
}

tmux() {
  if [ $# -eq 0 ]; then
    command tmux new -A -s default
  else
    command tmux "$@"
  fi
}

png() {
  # https://sw.kovidgoyal.net/kitty/graphics-protocol
  # local data=$(openssl base64 -in "$1" | tr -d '\n\r')
  # local data=$(/usr/bin/base64 -w0 $1)
  local data=$(/usr/bin/base64 < "$1")
  data="${data//[[:space:]]/}"

  local pos=0
  local size=4096

  while [ $pos -lt ${#data} ]; do
    # `a=T` - Transfer image
    # `f=100` - PNG
    printf "\\e_Ga=T,f=100,"
    local chunk="${data:$pos:$size}"
    pos=$(($pos + $size))
    [ $pos -lt ${#data} ] && printf "m=1"
    [ ${#chunk} -gt 0 ] && printf ";%s" "$chunk"
    printf "\\e\\\\"
  done
  printf "\n"
}

# function psql() {
#     if [ -t 0 ]; then
#         docker run -it --rm -v /run/postgresql:/run/postgresql postgres psql "$@"
#     else
#         docker run -i --rm -v /run/postgresql:/run/postgresql postgres psql "$@"
#     fi
# }

setopt histignorealldups sharehistory prompt_subst
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
PROMPT='%n@%m %~%F{blue}$(_b)%F{none} %# '

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
alias chrome="open -a 'Google Chrome'"

export CLICOLOR=1
export VISUAL="vim"
export EDITOR="vim"
export PYTHONNOUSERSITE=1
export PYTHONUNBUFFERED=1
export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=YES
export BAT_STYLE="plain"
export LANG="C.UTF-8"
export LANGUAGE="C.UTF-8"
export LC_ALL="C.UTF-8"
export TZ="Europe/Brussels"
export FZF_DEFAULT_COMMAND=''
export FZF_DEFAULT_OPTS='--no-sort --info=inline --ansi'
# export FZF_CTRL_T_COMMAND=''
# export FZF_CTRL_T_OPTS=''
# export FZF_ALT_C_COMMAND=''
# export FZF_ALT_C_OPTS=''
# export MOZ_ENABLE_WAYLAND=1
# export OZONE_PLATFORM=wayland
export NATS_URL="tls://nats.mnq.fr-par.scaleway.com:4222"

[ -f ~/.fzf/bin/fzf ] && export path=("${HOME}/.fzf/bin" $path) && source <(fzf --zsh)
[ -f ~/.local/bin/env ] && source ~/.local/bin/env

# undo => Ctrl-U
# stty -ixon => disable Ctrl-S / Ctrl-Q

###############################################################################

# export FZF_CTRL_T_COMMAND=''
# export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# export FZF_ALT_C_COMMAND='find . \( \
#     -name ".git" -o \
#     -name ".venv" -o \
#     -name "__pycache__" -o \
#     -name "node_modules" \
#   \) -prune -o -type d -print'
# export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -500'"

# [ -f ~/.cargo/env ] && export path=("${HOME}/.cargo/bin" $path) && source ~/.cargo/env

# export NNN_PLUG='p:preview-tui;f:fzcd'
# export NNN_FIFO='/tmp/nnn.fifo'
# export NNN_FCOLORS=''

# fd --type file --color=always | tree --fromfile -N

# local c=$(find "$d" \( \
#   -name ".git" -o \
#   -name ".venv" -o \
#   -name "__pycache__" -o \
#   -name "node_modules" \
# \) -prune -o -type d -print 2>/dev/null 

        # elif [[ {} == *.png ]]; then
        #   png="{}"
        #   if [ -f "$file" ]; then
        #     data=$(/usr/bin/base64 < "$png")
        #     data="${data//[[:space:]]/}"
        #     pos=0
        #     size=4096
        #     while [ $pos -lt ${#data} ]; do
        #       printf "\e_Ga=T,f=100,"
        #       chunk="${data:$pos:$size}"
        #       pos=$(($pos + $size))
        #       [ $pos -lt ${#data} ] && printf "m=1"
        #       [ ${#chunk} -gt 0 ] && printf ";%s" "$chunk"
        #       printf "\e\\"
        #     done
        #     printf "\n"
        #   fi


# --bind "enter:become(vim {} < /dev/tty > /dev/tty)")

# export FZF_DEFAULT_COMMAND='fd --type file --color=always --follow --hidden --exclude .git'
# export FZF_DEFAULT_OPTS='--info=inline --ansi --preview="bat --color=always --style=plain --line-range=:500 {}" --bind="enter:become(vim {})"'

# f(){
#   local d="${1:-.}"
#   if [[ -d "$d/.git" ]]; then
#     git -C "$d" ls-files -co --exclude-standard | fzf --info=inline --ansi --prompt "$d"/ --preview="bat --color=always --style=plain --line-range=:500 $d/{}" --bind "enter:become(vim $d/{})"
#   else
#     find "$d" \( \
#       -name ".git" -o \
#       -name ".venv" -o \
#       -name "__pycache__" -o \
#       -name "node_modules" \
#     \) -prune -o -type f -print 2>/dev/null | fzf --info=inline --ansi --prompt "$d"/ --preview="bat --color=always --style=plain --line-range=:500 {}" --bind "enter:become(vim {})"
#   fi
# }

