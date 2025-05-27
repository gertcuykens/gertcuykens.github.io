#!/bin/zsh
set -eEuxo pipefail

curl -fsSL https://github.com/restic/restic/releases/download/v0.18.0/restic_0.18.0_linux_amd64.bz2 -o restic.bz2
bunzip2 restic.bz2
chmod +x restic
mv restic /usr/local/bin/

# apt install bzip2

# restic forget --keep-daily 90
# restic prune
# restic check

# export AWS_ACCESS_KEY_ID=...
# export AWS_SECRET_ACCESS_KEY=...
# export RESTIC_REPOSITORY=s3:http://...
# export RESTIC_PASSWORD="..."

