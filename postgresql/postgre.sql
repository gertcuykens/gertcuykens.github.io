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

