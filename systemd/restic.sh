#!/bin/zsh
# set -eEuxo pipefail

backup() {
    print -r -- $1 $(date +'%y-%m-%d %H:%M:%S')
    restic backup --tag "$1" --stdin-filename "/home/gert/$1.sql.gz" --stdin-from-command -- pg_dump -O -Z 6 "$1"
    restic backup --tag "$1" "/home/gert/filestore/$1"
}

# typeset -a PG
PG=(...)
for DB ("$PG[@]") {
    backup $DB
}

# restic forget --keep-daily 90 --prune

