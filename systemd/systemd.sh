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

systemctl enable machines.target
systemctl cat machines.target
systemctl list-dependencies machines.target
journalctl -b 0 -u machines.target
# machinectl enable ...
#
# systemctl edit machines.target
# [Unit]
# After=postgresql.service
# Wants=postgresql.service
# systemctl daemon-reload
