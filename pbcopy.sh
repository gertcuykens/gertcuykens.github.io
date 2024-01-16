#!/bin/zsh
nc -z localhost 2000 && echo "port 2000 already in use" || while true; do
  nc -l localhost 2000 | pbcopy
  echo "updated pasteboard"
done

# ~/.ssh/config
# RemoteForward 2000 localhost:2000
# PermitLocalCommand yes
# LocalCommand ~/pbcopy.sh

# GatewayPorts yes
# ssh -NT clubit -R 2000:localhost:2000 
# echo "hhhhhhhh" | nc localhost 2000

