#!/usr/bin/env bash

DB_NAME="zabbix"
DB_NAME_PROXY=${DB_NAME}_proxy

# Note: symbols ".", "-" are not allowed in MySQL. Use "_" instead.

DB_HOST="127.0.0.1"

DB_ROOT_PASSWORD="password"
DB_USER="zabbix"
DB_PASSWORD="password"


sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} --execute="create database if not exists $DB_NAME character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} --execute="create user if not exists '$DB_USER'@'$DB_HOST' identified by '$DB_PASSWORD';"
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} --execute="grant all privileges on $DB_NAME.* to $DB_USER@'$DB_HOST';"


make dbschema

cd database/mysql

sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} $DB_NAME < schema.sql
# stop here if you are creating database for Zabbix proxy
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} $DB_NAME < images.sql
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} $DB_NAME < data.sql


# proxy
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} --execute="create database if not exists $DB_NAME_PROXY character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} --execute="create user if not exists '$DB_USER'@'$DB_HOST' identified by '$DB_PASSWORD';"
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} --execute="grant all privileges on $DB_NAME_PROXY.* to $DB_USER@'$DB_HOST';"
sudo mysql -h $DB_HOST -uroot -p${DB_ROOT_PASSWORD} $DB_NAME_PROXY < schema.sql

