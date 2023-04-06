#!/usr/bin/env bash

DB_NAME="zabbix"
DB_NAME_PROXY=${DB_NAME}_proxy

# Note: symbols ".", "-" are not allowed in MySQL. Use "_" instead.


DB_USER="zabbix"

sudo mysql -uroot -ppassword --execute="create database $DB_NAME character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -ppassword --execute="grant all privileges on $DB_NAME.* to $DB_USER@'localhost';"


make dbschema

cd database/mysql
mysql -uzabbix -ppassword $DB_NAME < schema.sql
# stop here if you are creating database for Zabbix proxy
mysql -uzabbix -ppassword $DB_NAME < images.sql
mysql -uzabbix -ppassword $DB_NAME < data.sql


# proxy
sudo mysql -uroot -ppassword --execute="create database $DB_NAME_PROXY character set utf8mb4 collate utf8mb4_bin;"
sudo mysql -uroot -ppassword --execute="grant all privileges on $DB_NAME_PROXY.* to $DB_USER@'localhost';"
mysql -uzabbix -ppassword $DB_NAME_PROXY < schema.sql

