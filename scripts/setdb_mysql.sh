#!/usr/bin/env bash

# Note: symbols ".", "-" are not allowed in MySQL. Use "_" instead.
DB_NAME="zabbix_int"
DB_NAME_PROXY=${DB_NAME}_proxy
DB_HOST="localhost"

# Zabbix 5.0
ZABBIX_5=false

DB_USER="zabbix"
DB_PASSWORD="password"
DB_ROOT_PASSWORD="password"

if [ "$ZABBIX_5" = false ]; then
    charset="utf8mb4"
    collate="utf8mb4_bin"
else
    charset="utf8"
    collate="utf8_bin"
fi


# drop
sudo mysql -uroot -p${DB_ROOT_PASSWORD} --execute="drop database if exists ${DB_NAME};"
sudo mysql -uroot -p${DB_ROOT_PASSWORD} --execute="drop database if exists ${DB_NAME_PROXY};"


make dbschema

# create
sudo mysql -uroot -p${DB_ROOT_PASSWORD} --execute="create database ${DB_NAME} character set ${charset} collate ${collate};"
sudo mysql -uroot -p${DB_ROOT_PASSWORD} --execute="grant all privileges on ${DB_NAME}.* to '${DB_USER}'@'${DB_HOST}';"

mysql -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < database/mysql/schema.sql
# stop here if you are creating database for Zabbix proxy
mysql -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < database/mysql/images.sql
mysql -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < database/mysql/data.sql


# proxy
sudo mysql -uroot -p${DB_ROOT_PASSWORD} --execute="create database ${DB_NAME_PROXY} character set ${charset} collate ${collate};"
sudo mysql -uroot -p${DB_ROOT_PASSWORD} --execute="grant all privileges on ${DB_NAME_PROXY}.* to '${DB_USER}'@'${DB_HOST}';"

mysql -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME_PROXY} < database/mysql/schema.sql



# ZBX-25468

# DIR="/home/mikhail/Downloads/ZBX-25468/mysql-7.0LTS"
# DIR="/home/mikhail/Downloads/ZBX-25468_2025_01_07"

# mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < "${DIR}/trends06012024_dump.sql"
# mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < "${DIR}/trends_uint06012024_dump.sql"


# mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < "${DIR}/trends07012025_dump.sql"
# mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < "${DIR}/trends_uint07012025_dump.sql"
