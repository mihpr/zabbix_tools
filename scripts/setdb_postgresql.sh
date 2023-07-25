#!/usr/bin/env bash

# Settings to be changed
DB_NAME="zabbix"

#################################
SERVER_ENABLED=true
TIMESCALE_ENABLED=false
PROXY_ENABLED=true
################################

DROP_DATABASE_ENABLED_SERVER=false
DROP_DATABASE_ENABLED_PROXY=false
CREATE_USER_ENABLED=false

# Const settings
DB_USER="zabbix"
DB_NAME_PROXY=${DB_NAME}_proxy


# user
if [ "$CREATE_USER_ENABLED" = true ]; then
    sudo -u postgres createuser --pwprompt $DB_USER
fi

# drop database
if [ "$DROP_DATABASE_ENABLED_SERVER" = true ]; then
    sudo -u postgres dropdb --if-exists $DB_NAME
fi

if [ "$DROP_DATABASE_ENABLED_PROXY" = true ]; then
    sudo -u postgres dropdb --if-exists $DB_NAME_PROXY
fi


if [ "$SERVER_ENABLED" = true ] || [ "$PROXY_ENABLED" = true ] ; then
    make dbschema
fi

# server
if [ "$SERVER_ENABLED" = true ]; then
    # postgres
    sudo -u postgres createdb -O $DB_USER -E Unicode -T template0 $DB_NAME

    cd database/postgresql
    cat schema.sql | sudo -u $DB_USER psql $DB_NAME
    # stop here if you are creating database for Zabbix proxy
    cat images.sql | sudo -u $DB_USER psql $DB_NAME
    cat data.sql | sudo -u $DB_USER psql $DB_NAME

    # timescale
    if [ "$TIMESCALE_ENABLED" = true ]; then
        echo "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;" | sudo -u postgres psql $DB_NAME
        cat timescaledb.sql | sudo -u $DB_USER psql $DB_NAME
    fi
fi


# proxy
if [ "$PROXY_ENABLED" = true ]; then
    sudo -u postgres createdb -O $DB_USER -E Unicode -T template0 $DB_NAME_PROXY

    cd database/postgresql
    cat schema.sql | sudo -u $DB_USER psql $DB_NAME_PROXY
fi
