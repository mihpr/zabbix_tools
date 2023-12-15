#!/usr/bin/env bash

DB_HOST=localhost
DB_USER="zabbix"
DB_NAME="zabbix"
DB_PASSWORD="password"

DB_DROP=true

# drop database
if [ "${DB_DROP}" = true ]; then
    mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="drop database if exists ${DB_NAME};"
fi

# Zabbix > 5.0
# mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="create database ${DB_NAME} character set utf8mb4 collate utf8mb4_bin;"
# Zabbix  5.0
mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="create database ${DB_NAME} character set utf8 collate utf8_bin;"

mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ~/dumps/my_${DB_NAME}.sql
