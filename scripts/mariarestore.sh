#!/usr/bin/env bash

DB_HOST=127.0.0.1
DB_USER="usr_owner"
DB_NAME="zabbix"
DB_PASSWORD="password"

DB_DROP=true

# mysql: Deprecated program name. It will be removed in a future release, use '/usr/bin/mariadb' instead

# drop database
if [ "${DB_DROP}" = true ]; then
    mariadb -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="drop database if exists ${DB_NAME};"
fi

mariadb -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="create database ${DB_NAME} character set utf8mb4 collate utf8mb4_bin;"

mariadb -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ~/dumps/${DB_NAME}_maria.sql
