#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

output_dir="dumps"
output_file="$output_dir/sales_data.sql"

if ! command -v docker >/dev/null 2>&1; then
    printf 'Error: Docker is required to export the database.\n' >&2
    exit 1
fi

if [[ -e "$output_file" ]]; then
    printf 'Error: %s already exists; move or remove it before exporting again.\n' "$output_file" >&2
    exit 1
fi

mkdir -p -- "$output_dir"
temporary_file="$(mktemp "$output_dir/.sales_data.sql.XXXXXX")"
trap 'rm -f -- "$temporary_file"' EXIT

docker compose exec -T mysql sh -c 'MYSQL_PWD="$MYSQL_PASSWORD" exec mysqldump --user="$MYSQL_USER" --single-transaction --skip-lock-tables --no-tablespaces sales sales_data' > "$temporary_file"

if [[ ! -s "$temporary_file" ]] || ! grep -q '^INSERT INTO `sales_data`' "$temporary_file"; then
    printf 'Error: export did not produce a non-empty sales_data table dump.\n' >&2
    exit 1
fi

mv -- "$temporary_file" "$output_file"
trap - EXIT
printf 'Export completed: %s\n' "$output_file"
