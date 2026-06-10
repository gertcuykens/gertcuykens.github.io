#!/bin/bash
# /usr/local/bin/microsocks.sh

while ! ifconfig -a inet 2>/dev/null | grep -Fq "inet 10.0.0.5"; do
    sleep 2
done

sleep 2

echo "starting microsocks"
exec /opt/homebrew/bin/microsocks -i 10.0.0.5 -p 1080

