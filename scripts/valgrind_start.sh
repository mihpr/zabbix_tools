#!/usr/bin/env bash

INSTALL_DIR="$PWD"
CONFIG_DIR="/usr/local/etc"

rm -rf /tmp/valgrind
mkdir -p /tmp/valgrind

# basic start

valgrind --leak-check=full --leak-resolution=high --show-leak-kinds=all --track-origins=yes --dsymutil=yes --error-limit=no --verbose --log-file=/tmp/valgrind/zabbix_server_%p ${INSTALL_DIR}/sbin/zabbix_server --config ${CONFIG_DIR}/zabbix_server.conf

# start in HA mode (active node)

# mkdir -p /tmp/ha1
# mkdir -p /tmp/ha2
# mkdir -p /tmp/ha3

# valgrind --leak-check=full --leak-resolution=high --show-leak-kinds=all --track-origins=yes --dsymutil=yes --error-limit=no --verbose --log-file=/tmp/valgrind/zabbix_server_%p ${INSTALL_DIR}/sbin/zabbix_server --config ${CONFIG_DIR}/zabbix_server_ha1.conf
