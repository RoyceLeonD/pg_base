# Contributing to PostgreSQL Advanced Container

Thank you for your interest in contributing to the PostgreSQL Advanced Container project! This guide outlines the roadmap, contribution workflow, and guidelines for enhancing this project.

## Project Roadmap

### Short-term Goals

- **Schema Management**: Integrate tools like [Sqitch](https://sqitch.org/) or [Liquibase](https://www.liquibase.org/) for database migrations and versioning
- **API Generation**: Add support for PostgREST or PostGraphile for automatic REST/GraphQL API generation
- **Caching Layer**: Complete Redis integration with proper configuration for caching
- **CI/CD Pipeline**: Add GitHub Actions workflows for testing and automatic building

### Medium-term Goals

- **Security Scanning**: Implement automated vulnerability scanning for container images
- **Performance Tuning**: Create specialized configurations for different workloads (OLTP, OLAP, mixed)
- **Monitoring Stack**: Add Prometheus/Grafana integration for advanced monitoring
- **Backup Solutions**: Implement WAL-E or pgBackRest integration for robust backups

### Long-term Vision

- **Multi-node Setup**: Support for PostgreSQL clustering with automatic failover
- **Kubernetes Integration**: Helm charts and operators for Kubernetes deployment
- **Plugin Architecture**: Modular extension system for custom functionality
- **AI Integration**: Built-in support for vector embeddings and AI operations

## Getting Started with Development

### Environment Setup

1. **Fork and clone the repository**:
   ```bash
   git clone https://github.com/yourusername/pg_base.git
   cd pg_base
   ```

2. **Install development dependencies**:
   - Docker and Docker Compose
   - Make
   - Git

### Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and test**:
   - Implement your changes
   - Use `make build` and `make start` to test locally
   - Add tests if applicable

3. **Commit your changes**:
   - Follow the [conventional commits](https://www.conventionalcommits.org/) format
   - Include thorough descriptions of changes

4. **Submit a pull request**:
   - Include a clear description of the changes
   - Link any related issues
   - Add documentation for new features

## Extension Development Guidelines

### Adding a New Extension

1. **Research extension compatibility** with PostgreSQL 17
2. **Update the Dockerfile** with necessary dependencies
3. **Add installation commands** in the Dockerfile
4. **Enable the extension** in `scripts/init-extensions.sql`
5. **Add tests** in `scripts/test-features.sql`
6. **Update the extensions table** in README.md

### Schema Management Integration

When implementing schema management, consider:

1. **Version control** for database schemas
2. **Migration scripts** that can be run during container initialization
3. **Rollback functionality** for failed migrations
4. **Documentation** for developers to add their own migrations

### API Layer Development

For integrating API generation capabilities:

1. **Evaluate** PostgREST, PostGraphile, and Hasura
2. **Create modular setup** that allows enabling/disabling components
3. **Secure configurations** with proper authentication and authorization
4. **Add documentation** for extending generated APIs

## Current Priorities

We're currently focused on:

1. **Schema migration system** for managing database versions
2. **Automated API generation** from database schemas
3. **Improved caching layer** with Redis integration
4. **CI/CD pipeline** for testing and building containers

## Code Style and Standards

- **SQL**: Follow PostgreSQL's [SQL Style Guide](https://www.postgresql.org/docs/current/sql-syntax.html)
- **Shell Scripts**: Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Markdown**: Use consistent formatting and structure
- **Dockerfile**: Follow best practices for multi-stage builds and layer optimization

## Testing Guidelines

- **Unit Tests**: Add pgTAP tests for database functions
- **Integration Tests**: Test extension interactions
- **Performance Tests**: Include benchmarks for significant changes

## Documentation Requirements

- **Update README.md** with new features or changes
- **Document usage examples** for new functionality
- **Keep the extensions table** up to date
- **Add inline comments** for complex code sections

## License

By contributing to this project, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).

## Questions or Suggestions?

If you have any questions or suggestions about the development roadmap or contribution process, please open an issue on GitHub.

---

Thank you for helping make the PostgreSQL Advanced Container better for everyone!

*- Royce Leon DSouza*