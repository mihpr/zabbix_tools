#!/usr/bin/env bash

# https://support.zabbix.com/browse/ZBX-16665 Use "Include What You Use" tool

BRANCH_DEV="feature/ZBXNEXT-9397-7.0"
BRANCH_RELEASE="release/7.0"


compile() {
	NUM=$1

	LOG_DIR=${HOME}/scripts/iwyu_log/
	LOG_FILE_IWYU=${LOG_DIR}log_iwyu_${NUM}.txt
	LOG_FILE_MAKE=${LOG_DIR}log_make_${NUM}.txt

	DB_KEY="--with-postgresql"

	mkdir -p ${LOG_DIR}

	git clean -dfx
	sh ./bootstrap.sh
	sh ./configure $DB_KEY --enable-server --enable-agent --enable-proxy --with-libcurl --with-libxml2 --with-openssl --enable-ipv6 --with-net-snmp
	CC=include-what-you-use make --keep-going --environment-overrides 2>&1 | tee ${LOG_FILE_IWYU}

	make -j 1 2>&1 | tee ${LOG_FILE_MAKE}
}

#clang

export CC=clang
export CC=clang-12
export CFLAGS="-Wall -Wextra -Wenum-conversion -g -O2 -fsanitize=leak,address -Wcast-align -Wsign-conversion -Wcast-qual -Wconversion"
export LDFLAGS="-fsanitize=leak,address"



git checkout $(git merge-base ${BRANCH_DEV} ${BRANCH_RELEASE})
compile 0

git checkout ${BRANCH_DEV}
compile 1
