#!/bin/bash
# ~/.config/sway/bar.sh

while true; do
    STATUS=$(cat /sys/class/power_supply/BAT1/status)
    BAT=$(cat /sys/class/power_supply/BAT1/capacity)
    DATE=$(date "+%H:%M:%S")

    case "$STATUS" in
        Charging)
            ICON="⚡"  # Unicode character for charging
            ;;
        Discharging)
            if [ "$BAT" -ge 20 ]; then
                ICON="🔋"
            else
                ICON="🪫"
            fi
            ;;
        Full)
            ICON="✅"
            ;;
        *)
            ICON="❓️"
            ;;
    esac

    echo "$ICON $BAT% | $DATE"
    sleep 1
done

