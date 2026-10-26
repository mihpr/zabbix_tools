#!/usr/bin/env bash
#
# Restores ${DUMPS_HOME}/pg_<DB_NAME_FROM>.sql into DB_NAME_TO (dropped first if DB_DROP=true)
# Usage: ./pgrestore.sh DB_NAME_FROM DB_NAME_TO   (e.g. ./pgrestore.sh zabbix_10 zabbix)

# ----------------------------------------------------------------------------------------------------------------------
# Settings
# ----------------------------------------------------------------------------------------------------------------------
DB_HOST=localhost
DB_USER="zabbix"
DB_POSTGRES_PASSWORD="password"
DB_DROP=true
DUMPS_HOME="${HOME}/dumps/bak"

# ----------------------------------------------------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------------------------------------------------
usage() {
    echo "Usage: $(basename "$0") DB_NAME_FROM DB_NAME_TO" >&2
    exit 1
}

restore_db() {
    local DB_NAME_FROM="$1"
    local DB_NAME_TO="$2"
    local DUMP_FILE="${DUMPS_HOME}/pg_${DB_NAME_FROM}.sql"

    # Stop before dropping anything if the dump file doesn't exist
    if [ ! -f "${DUMP_FILE}" ]; then
        echo "Dump not found: ${DUMP_FILE}" >&2
        return 1
    fi

    # Drop database if DB_DROP is true
    if [ "${DB_DROP}" = true ]; then
        PGPASSWORD="${DB_POSTGRES_PASSWORD}" dropdb -U postgres -h "${DB_HOST}" -f "${DB_NAME_TO}"
    fi

    # Create database
    PGPASSWORD="${DB_POSTGRES_PASSWORD}" createdb -U postgres -h "${DB_HOST}" -O "${DB_USER}" -E Unicode -T template0 "${DB_NAME_TO}"

    # Restore the database from the dump
    PGPASSWORD="${DB_POSTGRES_PASSWORD}" psql -U postgres -d "${DB_NAME_TO}" -h "${DB_HOST}" -f "${DUMP_FILE}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------------------------------------------------
[[ $# -eq 2 ]] || usage

restore_db "$1" "$2"
