#!/bin/zsh
set -eEuxo pipefail

createdb -U postgres -O postgres bench
pgbench -U postgres -i -s 100 bench
pgbench -U postgres -c 10 -j 2 -t 10000 bench
dropdb -U postgres bench

# docker run --rm colinianking/stress-ng --matrix 0 -t 120s --metrics-brief

