setopt histignorealldups sharehistory prompt_subst

export CLICOLOR=1
export VISUAL="vim"
export EDITOR="vim"
export PYTHONNOUSERSITE=1
export PYTHONUNBUFFERED=1
export BAT_STYLE="plain"
export LANG="C.UTF-8"
export LANGUAGE="C.UTF-8"
export LC_ALL="C.UTF-8"
export TZ="Europe/Brussels"
# export MOZ_ENABLE_WAYLAND=1
# export OZONE_PLATFORM=wayland
# export SHELL_SESSION_DISABLE=1
# export ZSH=~/.local/share/oh-my-zsh

# tree -N -C {} -I ".git|.venv|__pycache__|node_modules" | head -500
fdf() {
  local d="${2:-.}"
  [[ "$d" != */ ]] && d="$d/"
  local p=$( (echo "$d"; fd . "$d" --full-path --follow --hidden \
    --exclude .git \
    --exclude .venv \
    --exclude __pycache__ \
    --exclude node_modules) \
    | fzf --no-sort --info=inline \
      --prompt "$d > " \
      --query="${1}" \
      --preview='
        if [[ -d {} ]]; then
          eza --tree --icons=always --git --git-ignore {}
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

rgf() {
  local d="${2:-.}"
  : | fzf --no-sort --info=inline --ansi --disabled \
    --bind "start:reload:rg --with-filename --color=always --line-number --no-heading --smart-case \"${1}\" \"$d\" || true" \
    --bind "change:reload:rg --with-filename --color=always --line-number --no-heading --smart-case {q} \"$d\"  || true" \
    --bind "enter:become(vim {1} +{2})" \
    --delimiter ':' \
    --nth 3.. \
    --prompt="$d > " \
    --query="${1}" \
    --preview='
      FILE={1}
      LINE=$(echo {2} | grep -o "^[0-9]*$")
      if [[ -n "$LINE" ]]; then
        START=$((LINE>5 ? LINE-5 : 1))
        END=$((LINE+5))
        bat --color=always --style=plain --line-range $START:$END --highlight-line=$LINE "$FILE"
      else
        bat --color=always --style=plain "$FILE"
      fi' \
    --preview-window=up:11
}

gr() {
  local d="${2:-.}"
  [[ "$d" != */ ]] && d="$d/"
  : | fzf --no-sort --info=inline --ansi --disabled \
    --bind "start:reload:git -C \"$d\" grep --color=always --line-number \"${1}\" || true" \
    --bind "change:reload:git -C \"$d\" grep --color=always --line-number {q} || true" \
    --bind "enter:become(vim \"$d\"{1} +{2})" \
    --delimiter : \
    --nth 3.. \
    --prompt="$d > " \
    --query="${1}" \
    --preview='
      FILE={1}
      LINE=$(echo {2} | grep -o "^[0-9]*$")
      if [[ -n "$LINE" ]]; then
        START=$((LINE>5 ? LINE-5 : 1))
        END=$((LINE+5))
        bat --color=always --style=plain --line-range $START:$END --highlight-line=$LINE "$FILE"
      else
        bat --color=always --style=plain "$FILE"
      fi' \
    --preview-window=up:11
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

tag() {
    [[ -z "$1" ]] && { echo "Usage: tag <file_path> [<search_pattern>]"; return 1; }

    if [[ -z "$2" ]]; then
        tail -f "$1" | bat --paging=never --unbuffered --language=log
        return 0
    fi

    tail -f "$1" | rg --line-buffered --color=always "$2" | bat --paging=never --language=log
}

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.local/state/zsh/history
fpath=(~/.local/share/zsh/site-functions $fpath)

source ~/.local/share/zsh/syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.local/share/zsh/autosuggestions/zsh-autosuggestions.zsh
source ~/.local/share/zsh/history-substring-search/zsh-history-substring-search.zsh
source ~/.local/share/zsh/key-bindings.zsh
source ~/.local/share/zsh/completion.zsh
[ -f ~/.local/bin/env ] && source ~/.local/bin/env

zmodload zsh/complist
autoload -Uz compinit && compinit -d ~/.cache/zsh/zcompdump

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache

alias ls='eza --icons=always --color=always'
alias la='eza -a --icons=always'
alias ll='eza -lF --icons=always --git --git-ignore'
alias lt='eza --tree --icons=always --git --git-ignore'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias chrome="open -a 'Google Chrome'"

# bindkey -e -L
bindkey ${terminfo[kcuu1]} history-substring-search-up
bindkey ${terminfo[kcud1]} history-substring-search-down

# undo => Ctrl-U
# start / end =>  Ctrl-A / Ctrl-E
# stty -ixon => disable Ctrl-S / Ctrl-Q

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

###############################################################################

# _b() {
#   # git rev-parse --abbrev-ref HEAD 2>/dev/null
#   local b="$(git symbolic-ref --short HEAD 2>/dev/null)"
#   if [[ "${b}" != "" ]]; then
#     echo " ${b}"
#   else
#     echo ""
#   fi
# }

# PROMPT='%n@%m %~%F{blue}$(_b)%F{none} %# '

