#!/usr/bin/env bash

DB_USER="zabbix"
DB_NAME="deprecated"

cat database/postgresql/timescaledb/option-patches/with-compression/history_upgrade_prepare.sql | sudo -u $DB_USER psql $DB_NAME

cat database/postgresql/timescaledb/option-patches/with-compression/history_upgrade.sql | sudo -u $DB_USER psql $DB_NAME
cat database/postgresql/timescaledb/option-patches/with-compression/history_upgrade_uint.sql | sudo -u $DB_USER psql $DB_NAME
cat database/postgresql/timescaledb/option-patches/with-compression/history_upgrade_log.sql | sudo -u $DB_USER psql $DB_NAME
cat database/postgresql/timescaledb/option-patches/with-compression/history_upgrade_str.sql | sudo -u $DB_USER psql $DB_NAME
cat database/postgresql/timescaledb/option-patches/with-compression/history_upgrade_text.sql | sudo -u $DB_USER psql $DB_NAME
cat database/postgresql/timescaledb/option-patches/with-compression/trends_upgrade.sql | sudo -u $DB_USER psql $DB_NAME