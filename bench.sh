#!/bin/zsh
set -eEuxo pipefail

docker exec postgres createdb -U postgres -O postgres bench
docker exec postgres pgbench -U postgres -i -s 100 bench
docker exec postgres pgbench -U postgres -c 10 -j 10 -t 10000 bench
docker exec postgres dropdb -U postgres bench

docker run --rm colinianking/stress-ng --matrix 0 -t 120s --metrics-brief

