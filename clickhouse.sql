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

CREATE ROLE clickhouse WITH LOGIN REPLICATION PASSWORD '...';
GRANT CONNECT ON DATABASE ... TO clickhouse;
GRANT USAGE ON SCHEMA public TO clickhouse;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO clickhouse;
ALTER DEFAULT PRIVILEGES FOR ROLE table_creator_role IN SCHEMA public GRANT SELECT ON TABLES TO clickhouse;
CREATE PUBLICATION ..._ch_publication FOR TABLE public.users;
SELECT pg_create_logical_replication_slot('..._slot', 'pgoutput');
ALTER USER clickhouse WITH SUPERUSER;

REASSIGN OWNED BY clickhouse TO postgres;
DROP OWNED BY clickhouse;
DROP ROLE clickhouse;
ALTER ROLE clickhouse NOSUPERUSER;
ALTER DEFAULT PRIVILEGES FOR ROLE table_creator_role IN SCHEMA public REVOKE SELECT ON TABLES FROM clickhouse;

ALTER TABLE ... REPLICA IDENTITY FULL;

--

DESCRIBE TABLE postgresql('localhost:5432', 'db_name', 'table_name', 'clickhouse', '...');

SET allow_experimental_database_materialized_postgresql = 1;
CREATE DATABASE ...db_name ENGINE = MaterializedPostgreSQL('localhost:5432', 'db_name', 'clickhouse', '...'
)SETTINGS materialized_postgresql_tables_list = '...,...';
          -- materialized_postgresql_replication_slot = '..._slot',
          -- materialized_postgresql_snapshot = '..._ch_publication';

SELECT name, engine, metadata_path, uuid FROM system.databases WHERE name = '...';

SELECT count() FROM d.t;

DROP DATABASE IF EXISTS ...;

SELECT slot_name, plugin, slot_type, active FROM pg_replication_slots;
SELECT pg_drop_replication_slot('...');
ALTER SYSTEM SET wal_level = 'replica';
