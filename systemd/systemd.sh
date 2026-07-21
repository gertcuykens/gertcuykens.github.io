#!/bin/zsh
set -eEuxo pipefail

hostnamectl set-hostname ...

timedatectl list-timezones
timedatectl set-timezone Europe/Brussels
timedatectl set-ntp true

systemd-cgtop -d 1
systemd-cgls

# apt install systemd-timesyncd
# systemctl enable --now systemd-timesyncd