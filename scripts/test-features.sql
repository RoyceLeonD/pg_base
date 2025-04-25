-- Connect to our application database
\c ${POSTGRES_DB};

-- Test Scheduled Tasks
SELECT * FROM cron.job;
SELECT * FROM customers WHERE name = 'Cron User' LIMIT 5;

-- Test HTTP Extension
SELECT status, content_type, content::json->'args' 
FROM http_get('https://httpbin.org/get?test=success');

-- Test FDW functionality (placeholder - requires actual remote server)
-- CREATE SERVER remote_server
--    FOREIGN DATA WRAPPER postgres_fdw
--    OPTIONS (host 'remote-host', port '5432', dbname 'remote_db');

-- Test Notification System
-- Run in separate session:
-- LISTEN data_changes;

-- And in another session:
INSERT INTO customers (name, email) VALUES ('Test Notification', 'notify@example.com');

-- Test Redis connectivity (requires Redis server)
-- CREATE SERVER redis_server
--    FOREIGN DATA WRAPPER redis_fdw
--    OPTIONS (address '127.0.0.1', port '6379');