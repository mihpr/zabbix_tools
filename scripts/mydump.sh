#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------------------------------------
# Settings
# ----------------------------------------------------------------------------------------------------------------------
DB_HOST=localhost
DB_USER="zabbix"
DB_PASSWORD="password"

# ----------------------------------------------------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------------------------------------------------
backup_db() {
    local DB_NAME=$1
    mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --databases ${DB_NAME} > ~/dumps/my_${DB_NAME}.sql
}

# ----------------------------------------------------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------------------------------------------------

backup_db "zabbix_int"
backup_db "zabbix_int_proxy"
