#!/usr/bin/env bash

# for valgrind
export CC=gcc
export CFLAGS="-g -O0"

# DB_KEY="--with-mysql"
DB_KEY="--with-postgresql"
# DB_KEY="--with-oracle=/opt/oracle/instantclient_21_11"

sudo git clean -dfx
sh ./bootstrap.sh

sh ./configure --prefix=${PWD}/install $DB_KEY --enable-server --enable-agent --enable-agent2 --enable-proxy --with-libcurl --with-libxml2 --with-openssl --enable-ipv6 --with-net-snmp

make -j -s && make -s install
