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

apt-mark showmanual
apt-mark showauto

apt-mark auto <package>
apt-mark manual <package>

apt-get download mypackage
dpkg-deb -x ...deb /tmp/pkg
diff -u /etc/...conf /tmp/pkg/etc/...conf

debsums -c -e  # -c: changed files, -e: config files
find /etc -type f | while read file; do 
  dpkg -S "$file" > /dev/null 2>&1 || echo "$file"
done

