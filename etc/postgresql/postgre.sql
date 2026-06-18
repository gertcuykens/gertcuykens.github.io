SELECT pg_size_pretty(pg_database_size(current_database())) AS db_size;

-------------------------------------------------------------------------------

-- \l+

SELECT
  datname AS database_name,
  pg_size_pretty(pg_database_size(datname)) AS db_size
FROM
  pg_database
ORDER BY
  pg_database_size(datname) DESC;

-------------------------------------------------------------------------------

-- \dt+

SELECT
    relname AS table_name,
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS index_and_toast_size,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM
    pg_catalog.pg_statio_user_tables
ORDER BY
    pg_total_relation_size(relid) DESC;

-------------------------------------------------------------------------------

SELECT
  n.nspname AS schema_name,
  c.relname AS index_name,
  pg_size_pretty(pg_relation_size(c.oid)) AS index_size
FROM
  pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE
  c.relkind = 'i' -- only indexes
  -- AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY
  pg_relation_size(c.oid) DESC;

-------------------------------------------------------------------------------

SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  t.relname AS toast_table,
  pg_size_pretty(pg_total_relation_size(t.oid)) AS toast_table_size
FROM
  pg_class c
  JOIN pg_namespace n ON n.oid = c.relnamespace
  LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
WHERE
  c.relkind = 'r' -- regular tables
  AND t.relname IS NOT NULL -- has a TOAST table
  -- AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY
  pg_total_relation_size(t.oid) DESC;

-------------------------------------------------------------------------------

SELECT column_name FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'ir_attachment';

-------------------------------------------------------------------------------

SELECT id, name, description, key, pg_size_pretty(pg_column_size(key)::bigint) AS key_size
FROM public.ir_attachment
WHERE key IS NOT NULL AND key <> ''
ORDER BY pg_column_size(key) DESC
LIMIT 10;

-------------------------------------------------------------------------------

ALTER DATABASE mydb SET log_statement = 'all';
ALTER DATABASE mydb SET log_statement = 'none';
ALTER DATABASE mydb SET log_min_duration_statement = 1000;

-- postgresql.auto.conf
ALTER SYSTEM SET log_statement = 'none';
ALTER SYSTEM RESET ALL
SELECT pg_reload_conf();

SHOW log_statement;
SELECT * FROM pg_catalog.pg_settings WHERE name = 'log_statement';

-------------------------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
DROP EXTENSION IF EXISTS pg_stat_statements;
SELECT pg_stat_statements_reset();

SELECT
    left(regexp_replace(query, '\s+', ' ', 'g'), 80) || '…' AS short_query,
    to_char(calls, 'FM999,999,999') AS calls,
    to_char((total_exec_time/1000) * interval '1 second', 'HH24:MI:SS.MS') AS total_time,
    to_char((mean_exec_time/1000) * interval '1 second', 'MI:SS.MS') AS avg_time,
    to_char(rows, 'FM999,999,999') AS rows
FROM pg_stat_statements
WHERE dbid = (SELECT oid FROM pg_database WHERE datname = 'mydb')
ORDER BY total_exec_time DESC
LIMIT 20;

-------------------------------------------------------------------------------

EXPLAIN (ANALYZE, BUFFERS)
CREATE INDEX CONCURRENTLY idx_mytable_id ON mytable (id);

-------------------------------------------------------------------------------

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;

-------------------------------------------------------------------------------
-- tsvector : text search vector
-- tsquery : text search query
-- to_tsvector : function that converts text into a text search vector
-- to_tsquery | plainto_tsquery : functions that convert text into a text search query

-- & = AND
-- | = OR
-- ! = NOT
-- :A-D weights
-- :* prefix search (postgr:* → “postgre”, “postgres”, etc.)

CREATE TABLE articles (
  id            bigserial PRIMARY KEY,
  title         text,
  tags          text,
  body          text,
  vector tsvector GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(tags,  '')), 'B') ||
    setweight(to_tsvector('english', coalesce(body,  '')), 'D')
  ) STORED
);

CREATE INDEX idx_articles_tsvector
  ON articles
  USING gin (vector);

WITH search AS (
  SELECT plainto_tsquery('english', 'postgres graph search') AS query
)

SELECT
  id,
  title,
  ts_rank_cd(  -- text rank coverage density
    vector,
    search.query,
    ARRAY[1.0, 0.6, 0.3, 0.1]  -- weights for A, B, C, D
  ) AS rank
FROM articles, search
WHERE vector @@ search.query
ORDER BY rank DESC;

-------------------------------------------------------------------------------

-- \du
-- pg_dump -U odoo -d ... -t ... --data-only --column-inserts

CREATE EXTENSION IF NOT EXISTS dblink;
SELECT dblink_connect('conn', 'host=localhost port=5432 dbname=... user=...');

UPDATE y
SET x = t.x
FROM dblink('conn', 'SELECT id, x FROM y')
AS t(id int, x int)
WHERE y.id = t.id;

-- psql -d ... -c "\copy ... FROM STDIN WITH (FORMAT CSV, HEADER)" < <(gzip -dc ...csv.gz)
-- psql -d ... -c "\copy ... TO STDOUT WITH (FORMAT CSV, HEADER, FORCE_QUOTE *)" | gzip > ...csv.gz

-- \copy is the client side COPY is the server side and needs superuser

-------------------------------------------------------------------------------

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '...'
  AND pid <> pg_backend_pid();

-------------------------------------------------------------------------------

