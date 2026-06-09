#!/bin/zsh
set -eEuxo pipefail

backup() {
    print -r -- "$1 $(date +'%y-%m-%d %H:%M:%S')"
    restic backup --tag "$1" --stdin-filename "/home/odoo/$1.dump" --stdin-from-command -- pg_dump -F c -b -O -x "$1"
    restic backup --tag "$1" "/home/gert/filestore/$1"
}

if [[ -z "${1:-}" ]]; then
    typeset -a PG
    PG=()
    for DB in "$PG[@]"; do
        backup "$DB"
    done
    # print -r "Error: Missing database name argument." >&2
    # exit 1
else
    backup "$1"
fi

# PG=( $(psql -Atc "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';") )

# restic backup --tag ... /home/...sql.gz
# pg_dump -U postgres -O -Z 6 ... | restic backup --stdin --stdin-filename=/home/...sql.gz

# restic forget latest --path /home/...sql.gz --unsafe-allow-remove-all
# restic forget --keep-daily 90
# restic prune
# restic check
# restic repair index
# restic repair snapshots --forget

# restic snapshots --latest 1 --group-by host
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

