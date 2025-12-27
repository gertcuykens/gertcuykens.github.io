#!/bin/zsh
set -eEuxo pipefail

# https://wiki.debian.org/SourcesList
# /etc/apt/sources.list.d/debian.sources
# Types: deb deb-src
# URIs: http://deb.debian.org/debian
# Suites: trixie trixie-updates trixie-security
# Components: main non-free-firmware
# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

# apt update
# apt upgrade
# apt install ca-certificates && update-ca-certificates
# apt install zsh vim curl git universal-ctags tree gnupg bzip2 smartmontools nvme-cli
# apt autoremove --purge
# apt clean

# infocmp -x xterm-ghostty | ssh root@... -- tic -x -

# chsh -s /bin/zsh root

curl -fsSLo ~/fd.deb https://github.com/sharkdp/fd/releases/download/v10.3.0/fd_10.3.0_amd64.deb
dpkg -i ~/fd.deb
rm ~/fd.deb

curl -fsSLo ~/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep_15.1.0-1_amd64.deb | dpkg -i -
dpkg -i ~/ripgrep.deb
rm ~/ripgrep.deb

curl -fsSLo ~/bat.deb https://github.com/sharkdp/bat/releases/download/v0.26.0/bat_0.26.1_amd64.deb | dpkg -i -
dpkg -i ~/bat.deb
rm ~/bat.deb

curl -fsSLo ~/fzf.tgz https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-linux_amd64.tar.gz
tar -xzf ~/fzf.tgz fzf
install -D -m 0755 fzf /usr/local/bin
rm -f ~/fzf.tgz ~/fzf

# typeset -U fpath
# type python3
# whence -av python3
# command -v python3

# rm -rf /var/lib/apt/lists/*
# rm -rf /tmp/*
# rm -rf /var/tmp/*

smartctl --scan
smartctl -a /dev/nvme0
nvme list
nvme smart-log /dev/nvme0 -H
nvme error-log /dev/nvme0

lsblk
mdadm --detail /dev/md1
echo check > /sys/block/md1/md/sync_action # repair
cat /sys/block/md1/md/mismatch_cnt
cat /proc/mdstat

xfs_info / | grep ftype
xfs_scrub -v -n /

e2fsck -f /dev/md1

