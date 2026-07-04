#!/bin/zsh
set -eEuxo pipefail

dpkg -l              # packages
dpkg-query -W -f='${binary:Package}\n'

dpkg -s <package>    # summary
dpkg -p <package>    # metadata

dpkg -L <package>    # files
dpkg -S <file>       # package

dpkg --clear-selections
dpkg --get-selections > selections.txt
dpkg --set-selections < selections.txt
apt-get -s dselect-upgrade

apt show <package>
apt-cache rdepends --installed <package>

apt-mark minimize-manual
apt-mark showmanual
apt-mark showauto

apt-mark auto <package>
apt-mark manual <package>

apt-get download mypackage
dpkg-deb -x ...deb /tmp/pkg
diff -u /etc/...conf /tmp/pkg/etc/...conf

# apt rdepends sysvinit-utils

debsums -c -e  # -c: changed files, -e: config files
cruft-ng > cruft.txt
updatedb

fd . /etc -t f --full-path --hidden \
    --exclude .git \
    --exclude .venv \
    --exclude __pycache__ \
    --exclude node_modules -0 | sort -z | while IFS= read -r -d '' file; do
  dpkg -S "$file" > /dev/null 2>&1 || echo "$file"
done

# update-alternatives --display awk
# update-alternatives --config iptables

# https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.2.0-amd64-netinst.iso
# https://wiki.debian.org/SourcesList
# https://packages.debian.org/name
# https://packages.debian.org/src:name
# https://packages.debian.org/file:path

# /etc/cruft/ignore
# /etc/letsencrypt
# /var/lib/docker
# /var/lib/containerd
# /var/lib/authn
# /var/lib/clickhouse
# /var/log/letsencrypt
# /usr/local/lib/zig

