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

