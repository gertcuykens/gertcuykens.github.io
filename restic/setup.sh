#!/bin/zsh
set -eEuxo pipefail

# curl -fsSL https://api.github.com/repos/restic/restic/releases/latest | jq -r .tag_name
RESTIC_VERSION=0.18.1
curl -fsSLo ~/restic.bz2 https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2
bunzip2 ~/restic.bz2
install -D -m 0755 ~/restic /usr/local/bin
rm ~/restic
restic generate --zsh-completion /usr/share/zsh/vendor-completions/_restic

# ~/.zshenv
# export AWS_ACCESS_KEY_ID=...
# export AWS_SECRET_ACCESS_KEY=...
# export RESTIC_REPOSITORY=s3:http://...
# export RESTIC_PASSWORD="..."

