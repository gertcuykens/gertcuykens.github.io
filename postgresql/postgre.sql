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

SELECT
  *,
  pg_size_pretty(pg_column_size(id)) AS id_size,
  pg_size_pretty(pg_column_size(name)) AS name_size,
  pg_size_pretty(pg_column_size(description)) AS description_size,
  pg_size_pretty(pg_column_size(res_model)) AS res_model_size,
  pg_size_pretty(pg_column_size(res_field)) AS res_field_size,
  pg_size_pretty(pg_column_size(res_id)) AS res_id_size,
  pg_size_pretty(pg_column_size(company_id)) AS company_id_size,
  pg_size_pretty(pg_column_size(type)) AS type_size,
  pg_size_pretty(pg_column_size(url)) AS url_size,
  pg_size_pretty(pg_column_size(public)) AS public_size,
  pg_size_pretty(pg_column_size(access_token)) AS access_token_size,
  pg_size_pretty(pg_column_size(db_datas)) AS db_datas_size,
  pg_size_pretty(pg_column_size(store_fname)) AS store_fname_size,
  pg_size_pretty(pg_column_size(file_size)) AS file_size_size,
  pg_size_pretty(pg_column_size(checksum)) AS checksum_size,
  pg_size_pretty(pg_column_size(mimetype)) AS mimetype_size,
  pg_size_pretty(pg_column_size(index_content)) AS index_content_size,
  pg_size_pretty(pg_column_size(create_uid)) AS create_uid_size,
  pg_size_pretty(pg_column_size(create_date)) AS create_date_size,
  pg_size_pretty(pg_column_size(write_uid)) AS write_uid_size,
  pg_size_pretty(pg_column_size(write_date)) AS write_date_size,
  pg_size_pretty(pg_column_size(original_id)) AS original_id_size,
  pg_size_pretty(pg_column_size(website_id)) AS website_id_size,
  pg_size_pretty(pg_column_size(key)) AS key_size,
  pg_size_pretty(pg_column_size(theme_template_id)) AS theme_template_id_size
FROM public.ir_attachment;

SELECT
  id, name, description,
  pg_size_pretty(pg_column_size(id)::bigint) AS id_size,
FROM public.ir_attachment
ORDER BY pg_column_size(id) DESC
LIMIT 10;

