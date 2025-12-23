#!/bin/zsh
set -eEuxo pipefail

# apt install bzip2

mkdir -p ~/.local/bin
curl -fsSLo ~/.local/bin/restic.bz2 https://github.com/restic/restic/releases/download/v0.18.1/restic_0.18.1_linux_amd64.bz2
# curl -fsSLo ~/.local/bin/restic.bz2 https://github.com/restic/restic/releases/download/v0.18.1/restic_0.18.1_darwin_arm64.bz2
bunzip2 ~/.local/bin/restic.bz2
chmod +x ~/.local/bin/restic
restic generate --zsh-completion ~/.local/share/zsh/site-functions/_restic

# restic generate --zsh-completion /usr/local/share/zsh/site-functions/_restic
# restic init
# restic backup --tag ... /home/...
# restic forget --keep-daily 90
# restic prune
# restic check

# pg_dump -U postgres -O -Z 6 ... | restic backup --stdin --stdin-filename=...sql.gz
# restic dump latest ...sql.gz | gzip -d | psql -U odoo mydb

# export AWS_ACCESS_KEY_ID=...
# export AWS_SECRET_ACCESS_KEY=...
# export RESTIC_REPOSITORY=s3:http://...
# export RESTIC_PASSWORD="..."

