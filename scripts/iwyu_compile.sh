#!/usr/bin/env bash

# This script calls "Include What You Use" tool which is described in this ticket:
# https://support.zabbix.com/browse/ZBX-16665

# ---=== [Instructions] ===---

# [Before the first use]
# - Make sure iwyu tool is installed and works.
# - Add this script to PATH

# [Each time]
# - Go to Zabbix repository in command line.
# - Make sure there are not uncommitted changes in the repo.
# - Make sure the settings below are correct.
# - Clean thd old logs.
# - Run the script from the Zabbix repository.

# ---=== [Settings] ===---

BRANCH_DEV="feature/DEV-4051-7.0"
BRANCH_RELEASE="release/7.0"
LOG_DIR=${HOME}/scripts/iwyu_log/

run_test() {
	TEST_NAME=$1
	LOG_FILE_IWYU=${LOG_DIR}log_iwyu_${TEST_NAME}.txt
	LOG_FILE_MAKE=${LOG_DIR}log_make_${TEST_NAME}.txt

	export CC=clang
	export CC=clang-12
	export CFLAGS="-Wall -Wextra -Wenum-conversion -g -O2 -fsanitize=leak,address -Wcast-align -Wsign-conversion -Wcast-qual -Wconversion"
	export LDFLAGS="-fsanitize=leak,address"

	DB_KEY="--with-postgresql"

	sh ./bootstrap.sh
	sh ./configure $DB_KEY --enable-server --enable-agent --enable-proxy --with-libcurl --with-libxml2 --with-openssl --enable-ipv6 --with-net-snmp
	CC=include-what-you-use make --keep-going --environment-overrides 2>&1 | tee ${LOG_FILE_IWYU}

	make -j 1 2>&1 | tee ${LOG_FILE_MAKE}
}

# Preparing for tests
echo "IWUY_COMPILE: Creating log dir..."
mkdir -p ${LOG_DIR}
echo "IWUY_COMPILE: Cleaning uncommitted changes..."
git reset --hard
git clean -dfx
echo "IWUY_COMPILE: Fetching from remote with no pulling..."
git fetch
echo "IWUY_COMPILE: Checking out the development baranch..."
git checkout ${BRANCH_DEV}
echo "IWUY_COMPILE: Pulling the development baranch..."
git pull
echo "IWUY_COMPILE:  Checking out the release baranch..."
git checkout ${BRANCH_RELEASE}
echo "IWUY_COMPILE: Pulling the release baranch..."
git pull

# ---=== [Test RELEASE] ===---

# Test the evelopment branch
echo "IWUY_COMPILE: Starting test of the development barnch..."
run_test "RELEASE"

# ---=== [Test MERGED] ===---

# Test the changes merged from development branch to the release branch
echo "IWUY_COMPILE: Cleaning uncommitted changes..."
git reset --hard
git clean -dfx
echo "IWUY_COMPILE: Merging the changes from development barnch to the release branch with no commit..."
git merge --no-commit ${BRANCH_DEV}
echo "IWUY_COMPILE: Checking status..."
git status

echo "IWUY_COMPILE: Starting test of the changes merged from the development barnch to the release barnch..."
run_test "MERGED"

echo "IWUY_COMPILE: resetting the changes..."
git reset --hard
