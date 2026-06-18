#!/bin/zsh
set -eEuxo pipefail

psql -d mydb -c "\copy (
    SELECT
        query,
        to_char(calls, 'FM999,999,999') AS calls,
        to_char((total_exec_time/1000) * interval '1 second', 'HH24:MI:SS.MS') AS total_time,
        to_char((mean_exec_time/1000) * interval '1 second', 'MI:SS.MS') AS avg_time,
        to_char(rows, 'FM999,999,999') AS rows
    FROM pg_stat_statements
    WHERE dbid = (SELECT oid FROM pg_database WHERE datname = 'mydb')
    ORDER BY total_exec_time DESC
) TO STDOUT CSV HEADER FORCE QUOTE query;" > pg_stat.csv

