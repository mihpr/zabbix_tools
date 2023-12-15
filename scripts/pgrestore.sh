#!/usr/bin/env bash


DB_HOST=localhost
DB_USER="zabbix"
DB_NAME="zabbix"
DB_POSTGRES_PASSWORD="password"

DB_DROP=true

# drop database
if [ "${DB_DROP}" = true ]; then
    PGPASSWORD=${DB_POSTGRES_PASSWORD} dropdb -U postgres -h ${DB_HOST} -f ${DB_NAME}
fi

PGPASSWORD=${DB_POSTGRES_PASSWORD} createdb -U postgres -h ${DB_HOST} -O ${DB_USER} -E Unicode -T template0 ${DB_NAME}
PGPASSWORD=${DB_POSTGRES_PASSWORD} psql -U postgres -d ${DB_NAME} -h ${DB_HOST} -f ~/dumps/pg_${DB_NAME}.sql