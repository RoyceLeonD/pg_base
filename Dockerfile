# Use PostgreSQL 17 as the base image
FROM postgres:17

# Set labels for metadata
LABEL maintainer="Royce Leon DSouza"
LABEL description="Advanced PostgreSQL container with extensions for scheduling, API, pipelines, messaging, and caching"
LABEL version="1.0"
LABEL org.opencontainers.image.source="https://github.com/royceleond/pg_base"

# Security hardening
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Set secure permissions and create necessary directories
RUN mkdir -p /var/lib/postgresql/data /var/run/postgresql \
    && chown -R postgres:postgres /var/lib/postgresql /var/run/postgresql \
    && chmod 775 /var/lib/postgresql/data /var/run/postgresql

# Install build dependencies and extension dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libcurl4-openssl-dev \
    libkrb5-dev \
    libssl-dev \
    postgresql-server-dev-17 \
    pgxnclient \
    wget \
    unzip \
    cmake \
    pkg-config \
    # Message bus dependencies
    rabbitmq-server \
    # Caching dependencies
    memcached \
    redis-server \
    libmemcached-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy extension installation script
COPY scripts/install_extension.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install_extension.sh

# Install pg_cron
RUN apt-get update && apt-get install -y postgresql-17-cron || echo "WARNING: Failed to install postgresql-17-cron, will attempt to use pgxn" && \
    if [ ! -f "/usr/share/postgresql/17/extension/pg_cron.control" ]; then \
        . /usr/local/bin/install_extension.sh && \
        install_extension pg_cron pgxn install pg_cron; \
    fi && \
    rm -rf /var/lib/apt/lists/*

# Clone and build http extension
RUN . /usr/local/bin/install_extension.sh && \
    install_extension http cd /tmp && \
    git clone https://github.com/pramsey/pgsql-http.git && \
    cd /tmp/pgsql-http && \
    make && \
    make install

# We'll skip pg_net for now as it requires additional dependencies
RUN echo "NOTE: pg_net will be commented out in the init-extensions.sql file"

# Install Foreign Data Wrappers
RUN apt-get update && \
    apt-get install -y default-libmysqlclient-dev && \
    apt-get install -y postgresql-17-postgres-fdw || echo "WARNING: Failed to install postgres_fdw from apt" && \
    . /usr/local/bin/install_extension.sh && \
    install_extension mysql_fdw pgxn install mysql_fdw && \
    rm -rf /var/lib/apt/lists/*

# Skip message bus, memcached, and redis extensions for now
RUN echo "NOTE: Additional extensions will be disabled in init-extensions.sql"

# Verify installed extensions
RUN mkdir -p /docker-entrypoint-initdb.d/ && \
    echo "SELECT name, default_version, installed_version FROM pg_available_extensions WHERE installed_version IS NOT NULL ORDER BY name;" > /docker-entrypoint-initdb.d/00-verify-extensions.sql

# Copy custom PostgreSQL configuration file
COPY configs/postgresql.conf /etc/postgresql/postgresql.conf

# Create initialization scripts directory
RUN mkdir -p /docker-entrypoint-initdb.d/

# Add initialization script to enable extensions
COPY scripts/init-extensions.sql /docker-entrypoint-initdb.d/

# Expose PostgreSQL port
EXPOSE 5432

# Ensure all files belong to postgres user
RUN find /docker-entrypoint-initdb.d/ -type f -exec chmod 0755 {} \; \
    && find /docker-entrypoint-initdb.d/ -type f -exec chown postgres:postgres {} \; \
    && chown postgres:postgres /etc/postgresql/postgresql.conf \
    && chmod 0600 /etc/postgresql/postgresql.conf

# Remove unnecessary packages
RUN apt-get purge -y --auto-remove build-essential git wget unzip cmake pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Switch back to postgres user
USER postgres

# Use tini as init to handle signals properly
ENTRYPOINT ["/usr/bin/tini", "--"]

# Set the custom postgresql.conf as the configuration file
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
