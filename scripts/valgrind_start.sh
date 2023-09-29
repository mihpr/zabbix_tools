#!/usr/bin/env bash

rm -rf /tmp/valgrind
mkdir -p /tmp/valgrind

valgrind --leak-check=full --leak-resolution=high --show-leak-kinds=all --track-origins=yes --dsymutil=yes --error-limit=no --verbose --log-file=/tmp/valgrind/zabbix_server_%p /usr/local/sbin/zabbix_server
