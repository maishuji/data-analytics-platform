# Data Analytics Platform

## Getting Started

Install Docker Engine or Docker Desktop with the Docker Compose v2 plugin, then run from this repository:

```sh
cp .env.example .env
```

Edit `.env` and replace both password placeholders with distinct strong passwords before starting services. Do not commit this file.

```sh
docker compose config --quiet
docker compose up -d --wait --wait-timeout 180
```

Open <http://localhost:8080> and log in as `sales_user` with `MYSQL_PASSWORD` from `.env`. The `sales` database is created on first initialization; no tables or datasets are loaded yet.

## Overview

Local implementation of the IBM Data Engineering capstone, starting with Part 1's online transaction processing (OLTP) environment.

This initial setup provides MySQL and phpMyAdmin only. Schema creation, CSV import, the timestamp index, and the export script remain future work. The assessed database/table names are `sales.sales_data`.

The images use the MySQL 8.4 LTS and phpMyAdmin 5.2 release lines, rather than the course lab's MySQL 8.0.22 and phpMyAdmin 5.0.4. These tags may receive updates; they are not immutable digest pins. Record actual runtime versions when collecting lab evidence. Compatibility and runtime behavior have not yet been validated in this repository.

## Installation

A running Docker daemon and Docker Compose v2 supporting `up --wait` are required. No host MySQL installation is needed. Docker downloads images on first startup, requiring network access and local disk space.

Use the setup commands in Getting Started. If port 8080 is occupied, change `PHPMYADMIN_PORT` in `.env` and use that port in your browser.

MySQL is accessible only to services on the Compose network; its port is not published to the host. phpMyAdmin is bound to IPv4 localhost only. This is a local learning environment, not a production deployment. Credentials are passed through container environment variables and are visible to users with Docker access.

## Usage

```sh
# Inspect service health and recent logs.
docker compose ps
docker compose logs --tail=100 mysql phpmyadmin

# Open a MySQL session; enter MYSQL_PASSWORD when prompted.
docker compose exec mysql mysql --user=sales_user --password sales

# Record the database server version.
docker compose exec mysql mysql --user=sales_user --password --execute='SELECT VERSION();'

# Stop and remove containers/network while retaining the database volume.
docker compose down
```

MySQL data persists in the `mysql_data` named volume. Do not run `docker compose down --volumes` unless you intentionally want to delete the local database. A volume is persistence, not a backup.

Initialization variables (including passwords) apply only when the data directory is empty. Changing `.env` does not change existing database accounts; use an authenticated SQL session to rotate passwords and then update `.env` accordingly.

## Development / Testing

Validate Compose configuration without printing resolved credentials:

```sh
docker compose config --quiet
```

After startup, verify service health with `docker compose ps`, log in through phpMyAdmin, and execute `SELECT VERSION();` and `SHOW DATABASES;`. MySQL's health check authenticates as `sales_user` and queries the `sales` database; phpMyAdmin waits for it before starting.

These commands are provided for validation; they have not been executed in the initial authoring session. No automated tests are included yet.

Keep downloaded CSVs in ignored `data/` and generated exports in ignored `dumps/`. Keep future SQL source scripts tracked, but do not commit credentials or generated datasets. Do not create `sales_data` until the source CSV has been inspected for compatible types and the exact five required columns.

## Contributing

Keep changes focused on the current capstone step and include relevant validation results. Use Conventional Commit messages, for example `feat(infra): add local MySQL and phpMyAdmin stack`.

## License

No license has been selected or included in this repository.
