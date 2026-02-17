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

# restic backup --tag ... /home/...sql.gz
# pg_dump -U postgres -O -Z 6 ... | restic backup --stdin --stdin-filename=/home/...sql.gz

# restic forget latest --path /home/...sql.gz --unsafe-allow-remove-all
# restic forget --keep-daily 90
# restic prune
# restic check

# restic snapshots latest --path /home/...sql.gz --latest 1
# restic ls latest --path /home/...sql.gz /home/...sql.gz
# restic dump latest --path /home/...sql.gz /home/...sql.gz | gzip -d | head
# restic restore latest:/home/.../ --path /home/...sql.gz --include ...sql.gz --target . 

###############################################################################

# AWS_ACCESS_KEY_ID=...
# AWS_SECRET_ACCESS_KEY=...
# RESTIC_REPOSITORY=s3:http://...
# RESTIC_PASSWORD="..."

# restic init

