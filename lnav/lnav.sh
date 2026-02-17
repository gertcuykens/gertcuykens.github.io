#!/bin/zsh
lnav -i odoo_log.json
lnav <(journalctl -o cat -u 19.service -f) /var/log/postgresql/postgresql-18-main.log

# :config /ui/default-colors true
# :config /ui/theme-defs/default/styles/cursor-line/background-color #3D3D3D
# :save-config
# Press Ctrl+X to execute (if Enter just adds a line).

# journalctl -o json --output-fields=MESSAGE,PRIORITY,SYSLOG_IDENTIFIER,_PID,_SYSTEMD_UNIT,_SOURCE_REALTIME_TIMESTAMP,_HOSTNAME CONTAINER_NAME=... --since "2026-02-10 10:35:00" --until "2026-02-10 10:45:00" > logs.json

