# PostgreSQL Advanced Container

This project sets up a PostgreSQL 17 container with advanced extensions and features.

## Features

- **Core PostgreSQL 17** with optimized configuration
- **Scheduled Tasks** via `pg_cron`
- **External API Access** via `http` extension (pg_net is not included due to compilation issues)
- **Data Pipelines** via PostgreSQL Foreign Data Wrappers
- **Basic Extensions** including `hstore`, `pgcrypto`, and `pg_stat_statements`

## Project Structure

```
postgres-advanced/
├── .env                   # Environment variables
├── Dockerfile             # Docker container definition
├── Makefile               # Helpful commands
├── docker-compose.yml     # Service orchestration
├── configs/               # PostgreSQL configuration
│   └── postgresql.conf    # Database tuning parameters
└── scripts/               # Initialization scripts
    ├── init-extensions.sql # Extensions setup
    ├── test-features.sql  # Testing SQL scripts
    └── monitor.sh         # Monitoring utility
```

## Usage

1. Build the container: `make build`
2. Start the service: `make start`
3. Check status: `make monitor`
4. Connect to PostgreSQL: `make psql`
5. Check installed extensions: `make check-extensions`
6. Test features: `make test-features`
7. Stop when done: `make stop`

## Notes

Some extensions could not be included due to compatibility issues with PostgreSQL 17:

- pg_net (requires additional dependencies)
- mongo_fdw (requires additional compilation)
- amqp, pgmemcache, redis_fdw (require additional setup)

These extensions are commented out in the initialization script but can be enabled if the necessary dependencies are installed.

## Customization

To add more extensions, update both the Dockerfile and `scripts/init-extensions.sql` file.