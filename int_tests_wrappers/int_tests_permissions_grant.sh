#!/bin/bash

envname="zabbix_int"
db_name_server="${envname}"
db_name_proxy="${envname}_proxy"


user="zabbix"
user_password="password"

####################
# localhost
####################
# host="localhost"
# mysql_addr="localhost"
# mysql_admin_usr="root"
# mysql_admin_password="password"


####################
# docker
####################
# host="172.17.0.1"
# # container="172.17.0.2"
# mysql_addr="127.0.0.1"
# mysql_admin_usr="root"
# mysql_admin_password="password"


####################
# virtual machine
####################
host="192.168.56.201"
mysql_addr="192.168.56.203"
mysql_admin_usr="admin"
mysql_admin_password="password"

_exec_as_root() {
	command_to_exec=$1

	mysql -h ${mysql_addr} -u${mysql_admin_usr} -p${mysql_admin_password} --execute="${command_to_exec}"
}

# _exec_as_root "drop database if exists ${db_name_server};"
# _exec_as_root "drop database if exists ${db_name_proxy};"
# _exec_as_root "drop user if exists '${user}'@'${host}';"
# _exec_as_root "create user '${user}'@'${host}' identified by '${user_password}';"
# _exec_as_root "create database ${db_name_server} character set utf8mb4 collate utf8mb4_bin;"
# _exec_as_root "create database ${db_name_proxy} character set utf8mb4 collate utf8mb4_bin;"
# _exec_as_root "grant all privileges on ${db_name_server}.* to '${user}'@'${host}'";
# _exec_as_root "grant all privileges on ${db_name_proxy}.* to '${user}'@'${host}'";
# _exec_as_root "SET GLOBAL log_bin_trust_function_creators = 1;"
# _exec_as_root "drop database ${db_name_server};"
# _exec_as_root "drop database ${db_name_proxy};"


_exec_as_root "drop database if exists ${db_name_server};"
_exec_as_root "drop database if exists ${db_name_proxy};"
_exec_as_root "create user if not exists '${user}'@'${host}' identified by '${user_password}';"
_exec_as_root "grant all privileges on *.* to '${user}'@'${host}'";
# _exec_as_root "grant process on *.* to '${user}'@'${host}'";
_exec_as_root "SET GLOBAL log_bin_trust_function_creators = 1;"
_exec_as_root "FLUSH PRIVILEGES;"