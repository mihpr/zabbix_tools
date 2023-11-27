#!/usr/bin/env bash

DB_HOST=127.0.0.1
DB_USER="usr_bckp"
DB_PASSWORD="password"
DB_NAME="zabbix"

mariadb-dump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --databases ${DB_NAME} > ~/dumps/${DB_NAME}_maria.sql