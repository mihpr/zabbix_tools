#!/usr/bin/env bash

# Note: symbols ".", "-" are not allowed in MySQL. Use "_" instead.
DB_NAME="zabbix"
DB_NAME_PROXY="${DB_NAME}_proxy"
DB_HOST="192.168.56.203"

# Zabbix 5.0
ZABBIX_5=false

DB_ADMIN="admin"
DB_ADMIN_PASSWORD="password"
DB_USER="zabbix"
DB_PASSWORD="password"

CREATE_USER=false
DROP_DB=true
CREATE_SERVER=true
CREATE_PROXY=true

if [ "$ZABBIX_5" = false ]; then
    charset="utf8mb4"
    collate="utf8mb4_bin"
else
    charset="utf8"
    collate="utf8_bin"
fi


# create user
if [ "${CREATE_USER}" = true ]; then
    echo "[owl] create user..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION;"
fi

# drop
if [ "${DROP_DB}" = true ]; then
    echo "[owl] drop database ${DB_NAME}..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="drop database if exists ${DB_NAME};"
    echo "[owl] drop database ${DB_NAME_PROXY}..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="drop database if exists ${DB_NAME_PROXY};"
fi

# make dbschema
if [ "${CREATE_SERVER}" = true ] || [ "${CREATE_PROXY}" = true ]; then
    echo "[owl] make dbschema..."
    make dbschema
fi

# create server
if [ "${CREATE_SERVER}" = true ]; then
    echo "[owl] create server database ${DB_NAME}..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="create database ${DB_NAME} character set ${charset} collate ${collate};"
    echo "[owl] granting privileges on server database ${DB_NAME}..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="grant all privileges on ${DB_NAME}.* to '${DB_USER}'@'%';"

    echo "[owl] importing schema.sql on server database ${DB_NAME}..."
    mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < database/mysql/schema.sql
    # stop here if you are creating database for Zabbix proxy
    echo "[owl] importing images.sql on server database ${DB_NAME}..."
    mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < database/mysql/images.sql
    echo "[owl] importing data.sql on server database ${DB_NAME}..."
    mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < database/mysql/data.sql
fi

# create proxy
if [ "${CREATE_PROXY}" = true ]; then
    echo "[owl] create proxy database ${DB_NAME_PROXY}..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="create database ${DB_NAME_PROXY} character set ${charset} collate ${collate};"
    echo "[owl] granting privileges on proxy database ${DB_NAME_PROXY}..."
    sudo mysql -h ${DB_HOST} -u${DB_ADMIN} -p${DB_ADMIN_PASSWORD} --execute="grant all privileges on ${DB_NAME_PROXY}.* to '${DB_USER}'@'%';"

    echo "[owl] importing schema.sql on proxy database ${DB_NAME_PROXY}..."
    mysql -h ${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME_PROXY} < database/mysql/schema.sql
fi
