#!/usr/bin/env bash

DB_HOST=localhost
DB_USER="zabbix"
DB_PASSWORD="password"
DB_NAME="zabbix"

mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --databases ${DB_NAME} > ~/dumps/my_${DB_NAME}.sql