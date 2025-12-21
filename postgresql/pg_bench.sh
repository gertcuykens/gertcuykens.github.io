#!/bin/zsh
set -eEuxo pipefail

createdb -U postgres -O postgres pg_bench
pgbench -U postgres -i -s 100 pg_bench
pgbench -U postgres -c 10 -j 2 -t 10000 pg_bench
dropdb -U postgres pg_bench

# docker run --rm colinianking/stress-ng --matrix 0 -t 120s --metrics-brief

