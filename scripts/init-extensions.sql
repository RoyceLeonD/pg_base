-- Connect to our application database
\c ${POSTGRES_DB};

-- Function to safely create extensions
CREATE OR REPLACE FUNCTION safe_create_extension(ext_name TEXT) RETURNS TEXT AS $$
DECLARE
  result TEXT;
BEGIN
  BEGIN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS ' || ext_name;
    result := ext_name || ' extension created successfully';
  EXCEPTION WHEN OTHERS THEN
    result := 'WARNING: Could not create extension ' || ext_name || ': ' || SQLERRM;
  END;
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Create extensions safely
DO $$
DECLARE
  ext_result TEXT;
BEGIN
  -- Scheduled Tasks
  ext_result := safe_create_extension('pg_cron');
  RAISE NOTICE '%', ext_result;
  
  -- External API Access
  ext_result := safe_create_extension('http');
  RAISE NOTICE '%', ext_result;
  
  -- Skipping pg_net as it requires additional compilation
  -- ext_result := safe_create_extension('pg_net');
  -- RAISE NOTICE '%', ext_result;
  
  -- Data Pipelines
  ext_result := safe_create_extension('postgres_fdw');
  RAISE NOTICE '%', ext_result;
  
  ext_result := safe_create_extension('mysql_fdw');
  RAISE NOTICE '%', ext_result;
  
  -- Skipping mongo_fdw due to compilation issues
  -- ext_result := safe_create_extension('mongo_fdw');
  -- RAISE NOTICE '%', ext_result;
  
  -- Message Bus (disabled due to build issues)
  -- ext_result := safe_create_extension('amqp');
  -- RAISE NOTICE '%', ext_result;
  
  -- Caching System (disabled due to build issues)
  -- ext_result := safe_create_extension('pgmemcache');
  -- RAISE NOTICE '%', ext_result;
  
  -- ext_result := safe_create_extension('redis_fdw');
  -- RAISE NOTICE '%', ext_result;
END;
$$;

-- Additional useful extensions
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS hstore;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create a test table for the notification system demo
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT
);

-- Create a trigger function to send notifications
CREATE OR REPLACE FUNCTION notify_data_change() RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify(
        'data_changes',
        json_build_object(
            'table', TG_TABLE_NAME,
            'action', TG_OP,
            'data', row_to_json(NEW)
        )::text
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add a trigger to send notifications on changes
DROP TRIGGER IF EXISTS customers_notify ON customers;
CREATE TRIGGER customers_notify
AFTER INSERT OR UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION notify_data_change();

-- Create a test job with pg_cron
SELECT cron.schedule('test_job', '*/5 * * * *', 
    $$INSERT INTO customers(name, email) VALUES('Cron User', 'cron@example.com')$$);

-- Grant permissions
ALTER SCHEMA cron OWNER TO ${POSTGRES_USER};
GRANT USAGE ON SCHEMA cron TO ${POSTGRES_USER};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cron TO ${POSTGRES_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA cron TO ${POSTGRES_USER};