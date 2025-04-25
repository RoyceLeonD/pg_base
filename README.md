# PostgreSQL Advanced Container

A hardened PostgreSQL 17 container with advanced extensions for databases that need scheduling, API access, and data pipelines.

## Features

- **Security Hardened** PostgreSQL 17 with tini init process and proper permissions
- **Optimized Configuration** for better performance and monitoring
- **Extension-rich** for advanced database functionality

## Quick Start

```bash
# Clone the repository
git clone https://github.com/royceld/pg_base.git
cd pg_base

# Build and start PostgreSQL
make build
make start

# Verify it's working
make check-extensions
```

## Available Extensions

| Extension | Version | Category | Description | Status | Documentation |
|-----------|---------|----------|-------------|--------|---------------|
| pg_cron | 1.5+ | Scheduling | Job scheduler for PostgreSQL | ✅ Enabled | [GitHub](https://github.com/citusdata/pg_cron) |
| http | 1.5+ | API Access | HTTP client for PostgreSQL | ✅ Enabled | [GitHub](https://github.com/pramsey/pgsql-http) |
| pg_net | 0.7+ | API Access | Async HTTP client | ❌ Disabled | [GitHub](https://github.com/supabase/pg_net) |
| postgres_fdw | 1.1+ | Data Pipeline | Foreign data wrapper for PostgreSQL | ✅ Enabled | [Documentation](https://www.postgresql.org/docs/current/postgres-fdw.html) |
| mysql_fdw | 2.8+ | Data Pipeline | Foreign data wrapper for MySQL | ✅ Enabled | [GitHub](https://github.com/EnterpriseDB/mysql_fdw) |
| mongo_fdw | 5.5+ | Data Pipeline | Foreign data wrapper for MongoDB | ❌ Disabled | [GitHub](https://github.com/EnterpriseDB/mongo_fdw) |
| amqp | 1.0+ | Messaging | AMQP protocol support | ❌ Disabled | [GitHub](https://github.com/omniti-labs/pg_amqp) |
| pgmemcache | 2.3+ | Caching | Memcached client | ❌ Disabled | [GitHub](https://github.com/ohmu/pgmemcache) |
| redis_fdw | 1.0+ | Caching | Foreign data wrapper for Redis | ❌ Disabled | [GitHub](https://github.com/pg-redis-fdw/redis_fdw) |
| hstore | 1.8+ | Core | Key-value store | ✅ Enabled | [Documentation](https://www.postgresql.org/docs/current/hstore.html) |
| pgcrypto | 1.3+ | Core | Cryptographic functions | ✅ Enabled | [Documentation](https://www.postgresql.org/docs/current/pgcrypto.html) |
| pg_stat_statements | 1.10+ | Monitoring | Query statistics collector | ✅ Enabled | [Documentation](https://www.postgresql.org/docs/current/pgstatstatements.html) |

## Project Structure

```
postgres-advanced/
├── .env                   # Environment variables (create from .env.example)
├── Dockerfile             # Hardened Docker container definition
├── Makefile               # Helpful commands
├── docker-compose.yml     # Service orchestration
├── configs/               # PostgreSQL configuration
│   └── postgresql.conf    # Database tuning parameters
└── scripts/               # Initialization scripts
    ├── init-extensions.sql # Extensions setup
    ├── test-features.sql  # Testing SQL scripts
    ├── monitor.sh         # Monitoring utility
    └── publish.sh         # Registry publishing utility
```

## Usage Commands

| Command | Description |
|---------|-------------|
| `make build` | Build the PostgreSQL container |
| `make start` | Start the PostgreSQL container and dependent services |
| `make stop` | Stop running containers |
| `make restart` | Restart containers |
| `make clean` | Remove containers and volumes |
| `make logs` | Show logs from the PostgreSQL container |
| `make psql` | Connect to PostgreSQL with psql |
| `make test-features` | Run test script to verify features |
| `make monitor` | Monitor container status and show logs |
| `make check-extensions` | Check which PostgreSQL extensions are installed |
| `make publish` | Publish container to registry defined in .env |

## Security Features

This container has been hardened with several security measures:

- Uses `tini` as an init process to properly handle signals
- Runs as the `postgres` user (not root) for most operations
- Sets proper file permissions on critical files
- Removes build tools after installation
- Minimizes installed packages

## Custom Configuration

The PostgreSQL configuration in `configs/postgresql.conf` includes:

- Enhanced logging for debugging and monitoring
- Optimized memory settings for typical development workloads
- Extension configuration

## Enabling Disabled Extensions

To enable a currently disabled extension:

1. Uncomment the relevant section in `scripts/init-extensions.sql`
2. Update the Dockerfile to include the necessary dependencies
3. Rebuild the container with `make build`

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Author

Created and maintained by [Royce Leon DSouza](https://github.com/royceld).