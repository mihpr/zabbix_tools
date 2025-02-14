#!/usr/bin/env bash

# ----------------------------------------------------------------------------------------------------------------------
# Settings
# ----------------------------------------------------------------------------------------------------------------------
DB_HOST=localhost
DB_USER="zabbix"
DB_PASSWORD="password"
DB_DROP=true
IS_ZABBIX_GT_5=true  # Set to true if Zabbix > 5.0, false otherwise

# ----------------------------------------------------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------------------------------------------------
restore_db() {
    local DB_NAME=$1

    # Drop database if DB_DROP is true
    if [ "${DB_DROP}" = true ]; then
        mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="drop database if exists ${DB_NAME};"
    fi

    # Create database with utf8mb4 character set and collation for Zabbix > 5.0
    if [ "${IS_ZABBIX_GT_5}" = true ]; then
        mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="create database ${DB_NAME} character set utf8mb4 collate utf8mb4_bin;"
    else
        mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} --execute="create database ${DB_NAME} character set utf8 collate utf8_bin;"
    fi

    # Import the database dump
    mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ~/dumps/my_${DB_NAME}.sql
}

# ----------------------------------------------------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------------------------------------------------

restore_db "zabbix_int"
restore_db "zabbix_int_proxy"
