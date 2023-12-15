#!/usr/bin/env bash


DB_HOST=localhost
DB_USER="zabbix"
DB_PASSWORD="password"
DB_NAME="zabbix"


PGPASSWORD=${DB_PASSWORD} pg_dump -h ${DB_HOST} -f ~/dumps/pg_${DB_NAME}.sql -U${DB_USER} ${DB_NAME}