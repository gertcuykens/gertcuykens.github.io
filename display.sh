#!/bin/bash
# ~/.config/sway/display.sh

DISPLAY=eDP-1
ACTIVE=$(swaymsg -t get_outputs | jq --arg name "$DISPLAY" '.[] | select(.name==$name) | .active')

if [ "$ACTIVE" = "true" ]; then
    echo "$DISPLAY is active"
    swaymsg output $DISPLAY disable
else
    echo "$DISPLAY is inactive"
    swaymsg output $DISPLAY enable
fi

