#!/bin/zsh
set -eEuxo pipefail

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

FD_VERSION=10.3.0
curl -fsSLo ~/fd.deb https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd_${FD_VERSION}_amd64.deb
dpkg -i ~/fd.deb
rm ~/fd.deb

RG_VERSION=15.1.0
curl -fsSLo ~/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep_${RG_VERSION}-1_amd64.deb
dpkg -i ~/ripgrep.deb
rm ~/ripgrep.deb

BAT_VERSION=0.26.1
curl -fsSLo ~/bat.deb https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
dpkg -i ~/bat.deb
rm ~/bat.deb

FZF_VERSION=0.67.0
curl -fsSLo ~/fzf.tgz https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz
tar -C ~ -xzf ~/fzf.tgz fzf
install -D -m 0755 ~/fzf /usr/local/bin
rm -f ~/fzf.tgz ~/fzf
fzf --zsh > /usr/share/zsh/vendor-completions/_fzf

RESTIC_VERSION=0.18.1
curl -fsSLo ~/restic.bz2 https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2
bunzip2 ~/restic.bz2
install -D -m 0755 ~/restic /usr/local/bin
rm ~/restic
restic generate --zsh-completion /usr/share/zsh/vendor-completions/_restic

UV_VERSION=0.9.21
curl -fsSLo ~/uv.tgz https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz
tar -C ~ -xzf ~/uv.tgz
install -D -m 0755 ~/uv-x86_64-unknown-linux-gnu/uv /usr/local/bin
install -D -m 0755 ~/uv-x86_64-unknown-linux-gnu/uvx /usr/local/bin
rm -rf ~/uv.tgz ~/uv-x86_64-unknown-linux-gnu
uv generate-shell-completion zsh > /usr/share/zsh/vendor-completions/_uv
# curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh


LNAV_VERSION=0.14.0
curl -fsSLo ~/lnav.zip https://github.com/tstack/lnav/releases/download/v${LNAV_VERSION}-beta2/lnav-${LNAV_VERSION}-beta2-linux-musl-x86_64.zip
unzip ~/lnav.zip
install -D -m 0755 ~/lnav-${LNAV_VERSION}/lnav /usr/local/bin
rm ~/lnav.zip ~/lnav-${LNAV_VERSION}

ZIG_VERSION=0.0.0
curl -fsSLo /usr/share/zsh/vendor-completions/_zig https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig

# TODO: install ctags
# mkdir -p ~/.config/ctags
# curl -fsSLo ~/.config/ctags/py.ctags https://gert.ovh/.config/ctags/py.ctags
# ctags --list-kinds-full=Python
# ctags --verbose

# curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r .tag_name
# curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r .tag_name
# curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r .tag_name
# curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest | jq -r .tag_name
# curl -fsSL https://api.github.com/repos/restic/restic/releases/latest | jq -r .tag_name
# curl -fsSL https://api.github.com/repos/astral-sh/uv/releases/latest | jq -r .tag_name
# curl -fsSL https://api.github.com/repos/tstack/lnav/releases/latest | jq -r .tag_name

# curl -fsSL https://rclone.org/install.sh | zsh

# typeset -U fpath
# type python3
# whence -av python3
# command -v python3

# rm -rf /var/lib/apt/lists/*
# rm -rf /tmp/*
# rm -rf /var/tmp/*

# smartctl --scan
# smartctl -a /dev/nvme0
# nvme list
# nvme smart-log /dev/nvme0 -H
# nvme error-log /dev/nvme0

# lsblk
# mdadm --detail /dev/md1
# echo check > /sys/block/md1/md/sync_action # repair
# cat /sys/block/md1/md/mismatch_cnt
# cat /proc/mdstat

# xfs_info / | grep ftype
# xfs_scrub -v -n /

# e2fsck -f /dev/md1

# ip addr show ...
# lspci -vv -s ...
# ls -l /sys/class/net/.../device
# ls -l /sys/firmware/efi

