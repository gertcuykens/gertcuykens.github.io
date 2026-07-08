CREATE ROLE clickhouse WITH LOGIN REPLICATION PASSWORD '...' SUPERUSER;
GRANT CONNECT ON DATABASE ... TO clickhouse;
GRANT USAGE ON SCHEMA public TO clickhouse;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO clickhouse;
ALTER DEFAULT PRIVILEGES FOR ROLE table_creator_role IN SCHEMA public GRANT SELECT ON TABLES TO clickhouse;
\ddp *table_creator_role* \dp \dn \l

REASSIGN OWNED BY clickhouse TO postgres;
DROP OWNED BY clickhouse;
DROP ROLE clickhouse;
ALTER ROLE clickhouse NOSUPERUSER;
ALTER DEFAULT PRIVILEGES FOR ROLE table_creator_role IN SCHEMA public REVOKE SELECT ON TABLES FROM clickhouse;

CREATE PUBLICATION ..._ch_publication FOR TABLE public.users;
SELECT pg_create_logical_replication_slot('..._slot', 'pgoutput');

SELECT pg_terminate_backend(active_pid) 
FROM pg_replication_slots 
WHERE slot_name = '...' AND active = true;

SELECT pg_drop_replication_slot('...');

ALTER TABLE ... REPLICA IDENTITY FULL;
ALTER SYSTEM SET wal_level = 'replica';

SELECT
    slot_name, active,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), confirmed_flush_lsn)) AS wal,
    pg_current_wal_lsn(), confirmed_flush_lsn, restart_lsn
FROM pg_replication_slots
WHERE slot_type = 'logical';

SELECT
    application_name, client_addr, state,
    pg_wal_lsn_diff(pg_current_wal_lsn(), sent_lsn) AS sent,
    pg_wal_lsn_diff(sent_lsn, write_lsn) AS write,
    pg_wal_lsn_diff(write_lsn, flush_lsn) AS flush
FROM pg_stat_replication;

SELECT pid, age(clock_timestamp(), query_start), xact_start, query, state 
FROM pg_stat_activity 
WHERE state != 'idle' AND xact_start IS NOT NULL 
ORDER BY xact_start ASC;

--

DESCRIBE TABLE postgresql('localhost:5432', 'db_name', 'table_name', 'clickhouse', '...');

SET allow_experimental_database_materialized_postgresql = 1;

CREATE DATABASE ...db_name ENGINE = MaterializedPostgreSQL('localhost:5432', 'db_name', 'clickhouse', '...')
SETTINGS materialized_postgresql_tables_list = '...,...';
          -- materialized_postgresql_replication_slot = '..._slot',
          -- materialized_postgresql_snapshot = '..._ch_publication';

--

SELECT name, engine, metadata_path, uuid FROM system.databases WHERE name = '...';

SELECT
    p.database,
    p.table,
    formatReadableSize(sum(p.bytes_on_disk)) AS size_on_disk,
    sum(p.rows) AS total_rows,
    t.data_paths[1] AS disk_location
FROM system.parts AS p
LEFT JOIN system.tables AS t ON p.database = t.database AND p.table = t.name
WHERE p.database = '...'
GROUP BY p.database, p.table, t.data_paths;

SELECT 
    table,
    formatReadableSize(sum(total_bytes)) AS size_on_disk
FROM system.tables
WHERE database = 'system'
GROUP BY table
ORDER BY sum(total_bytes) DESC;

--

SELECT count() FROM d.t;
DROP DATABASE IF EXISTS ...;

ALTER USER default IDENTIFIED WITH sha256_password BY '...';
clickhouse hash-password --password '...'

CREATE USER superset IDENTIFIED WITH sha256_password BY '...';
GRANT SELECT, SHOW TABLES ON *.* TO superset;
ALTER USER superset SETTINGS readonly = 2;
SHOW GRANTS FOR superset;
DROP USER IF EXISTS superset;

--

CREATE TABLE events
(
    event_date Date,
    user_id    UInt64,
    event_type String,
    payload    String,
    INDEX idx_event_type event_type TYPE set(100) GRANULARITY 1
)
ENGINE = MergeTree
ORDER BY (event_date, user_id);

-- CREATE DATABASE testdb;
USE testdb;
SELECT currentDatabase();
-- CREATE TABLE test_table (
--     id UInt32,
--     name String
-- ) ENGINE = MergeTree()
-- ORDER BY id;
-- INSERT INTO test_table (id, name) VALUES (0, 'Hello world!');
SELECT * FROM test_table;

-- https://clickhouse.com/docs/operations/backup
-- BACKUP DATABASE testdb TO Disk('backups', 'test.tar.gz');
-- RESTORE DATABASE testdb AS testdb2 FROM Disk('s3_disk', 'test.tar.gz');

-- chc --queries-file /root/system/clickhouse.sql

