#!/usr/bin/env bash

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
restore_db() {
    local DB_NAME_FROM=$1
    local DB_NAME_TO=$2

    # Drop database if DB_DROP is true
    if [ "${DB_DROP}" = true ]; then
        PGPASSWORD=${DB_POSTGRES_PASSWORD} dropdb -U postgres -h ${DB_HOST} -f ${DB_NAME_TO}
    fi

    # Create database
    PGPASSWORD=${DB_POSTGRES_PASSWORD} createdb -U postgres -h ${DB_HOST} -O ${DB_USER} -E Unicode -T template0 ${DB_NAME_TO}

    # Restore the database from the dump
    PGPASSWORD=${DB_POSTGRES_PASSWORD} psql -U postgres -d ${DB_NAME_TO} -h ${DB_HOST} -f "${DUMPS_HOME}/pg_${DB_NAME_FROM}.sql"
}

# ----------------------------------------------------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------------------------------------------------

# restore_db <from> <to>
# restore_db "address" "address2"
# restore_db "zabbix_proxy" "zabbix_proxy2"


restore_db "exposed" "exposed"
restore_db "exposed_proxy" "exposed_proxy"
