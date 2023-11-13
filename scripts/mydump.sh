#!/usr/bin/env bash

DB_HOST=localhost
DB_USER="zabbix"
DB_PASSWORD="password"
DB_NAME="last_foreach"

mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --databases ${DB_NAME} > ~/dumps/${DB_NAME}_mysql.sql