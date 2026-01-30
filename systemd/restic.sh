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

# restic init
# restic backup --tag ... /home/...
# restic forget --path /home/...sql.gz latest --unsafe-allow-remove-all
# restic forget --keep-daily 90
# restic prune
# restic check

# restic snapshots --latest 1
# pg_dump -U postgres -O -Z 6 ... | restic backup --stdin --stdin-filename=/home/...sql.gz
# restic dump latest /home/...sql.gz --path /home/...sql.gz latest | gzip -d | psql ...
# restic restore latest --include /home/...sql.gz --target /home/...sql.gz

# AWS_ACCESS_KEY_ID=...
# AWS_SECRET_ACCESS_KEY=...
# RESTIC_REPOSITORY=s3:http://...
# RESTIC_PASSWORD="..."

