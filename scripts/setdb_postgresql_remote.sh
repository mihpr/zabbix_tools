#!/usr/bin/env bash

# Settings to be changed
DB_NAME="timescaledb217"
DB_NAME_PROXY=${DB_NAME}_proxy

DB_HOST="192.168.56.203"
# DB_PORT="5432" # 5432 is the dafault port
DB_USER="zabbix"
DB_PASSWORD="password"

DB_POSTGRES_PASSWORD="password" # password for admin user 'postgres'

#################################
SERVER_ENABLED=true
TIMESCALE_ENABLED=true
PROXY_ENABLED=false
################################

DROP_DATABASE_ENABLED_SERVER=true
DROP_DATABASE_ENABLED_PROXY=true
CREATE_USER_ENABLED=false

# user
if [ "$CREATE_USER_ENABLED" = true ]; then
	# createuser will prompt for passwords for user 'postgres' and the new user
	createuser -h $DB_HOST -U postgres -P $DB_USER
fi

# drop database
if [ "$DROP_DATABASE_ENABLED_SERVER" = true ]; then
	PGPASSWORD=$DB_POSTGRES_PASSWORD dropdb -h $DB_HOST -U postgres --force --if-exists $DB_NAME
fi

if [ "$DROP_DATABASE_ENABLED_PROXY" = true ]; then
	PGPASSWORD=$DB_POSTGRES_PASSWORD dropdb -h $DB_HOST -U postgres --force --if-exists $DB_NAME_PROXY
fi


if [ "$SERVER_ENABLED" = true ] || [ "$PROXY_ENABLED" = true ] ; then
	make dbschema
fi

# server
if [ "$SERVER_ENABLED" = true ]; then
	# PostgreSQL
	PGPASSWORD=$DB_POSTGRES_PASSWORD createdb -h $DB_HOST -U postgres -O $DB_USER -E Unicode -T template0 $DB_NAME

	PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -f 'database/postgresql/schema.sql' -d $DB_NAME
	# stop here if you are creating database for Zabbix proxy
	PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -f 'database/postgresql/images.sql' -d $DB_NAME
	PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -f 'database/postgresql/data.sql' -d $DB_NAME

	# timescale
	if [ "$TIMESCALE_ENABLED" = true ]; then
		echo "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;" | PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME
		if [ -f 'database/postgresql/timescaledb.sql' ]; then
			PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -f 'database/postgresql/timescaledb.sql' -d $DB_NAME
		elif [ -f 'database/postgresql/timescaledb/schema.sql' ]; then
			# after restructuring in ZBX-22307
			PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -f 'database/postgresql/timescaledb/schema.sql' -d $DB_NAME
		fi
	fi
fi

# proxy
if [ "$PROXY_ENABLED" = true ]; then
	PGPASSWORD=$DB_POSTGRES_PASSWORD createdb -h $DB_HOST -U postgres -O $DB_USER -E Unicode -T template0 $DB_NAME_PROXY

	# cat database/postgresql/schema.sql | sudo -u $DB_USER psql $DB_NAME_PROXY
	PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -f 'database/postgresql/schema.sql' -d $DB_NAME_PROXY
fi
