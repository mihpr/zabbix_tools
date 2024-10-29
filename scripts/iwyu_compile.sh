#!/usr/bin/env bash

# This script calls "Include What You Use" tool which is described in this ticket:
# https://support.zabbix.com/browse/ZBX-16665

# ---=== [Instructions] ===---

# [Before the first use]
# - Make sure iwyu tool is installed and works.
# - Add this script to PATH.
# - Configure log directory below.

# [Each time]
# - Go to Zabbix repository in command line.
# - Make sure there are no important uncommitted changes in the repo because they will be lost.
# - Make sure the settings below are correct.
# - Remember that old logs are deleted on test run.
# - Run the script from the Zabbix repository.

# ---=== [Settings] ===---

BRANCH_DEV="feature/ZBX-25390-6.0"
BRANCH_RELEASE="release/6.0"
LOG_DIR="${HOME}/scripts/iwyu_log/"
LOG_PREFIX="IWUY_WRAPPER"


# ---=== [Functions] ===---

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

# ---=== [Run] ===---

# Preparing for tests
echo "${LOG_PREFIX}: Removing old log dir..."
rm -rf ${LOG_DIR}
echo "${LOG_PREFIX}: Creating log dir..."
mkdir -p ${LOG_DIR}
echo "${LOG_PREFIX}: Cleaning uncommitted changes..."
git reset --hard
git clean -dfx
echo "${LOG_PREFIX}: Fetching from remote (with no merging)..."
git fetch
echo "${LOG_PREFIX}: Checking out the development baranch..."
git checkout ${BRANCH_DEV}
echo "${LOG_PREFIX}: Pulling the development baranch..."
git pull
echo "${LOG_PREFIX}:  Checking out the release baranch..."
git checkout ${BRANCH_RELEASE}
echo "${LOG_PREFIX}: Pulling the release baranch..."
git pull

# ---=== [Test RELEASE] ===---

# Test the evelopment branch
echo "${LOG_PREFIX}: Starting test of the development barnch..."
run_test "RELEASE"

# ---=== [Test MERGED] ===---

# Test the changes merged from development branch to the release branch
echo "${LOG_PREFIX}: Cleaning uncommitted changes..."
git reset --hard
git clean -dfx
echo "${LOG_PREFIX}: Merging the changes from development barnch to the release branch with no commit..."
git merge --no-commit ${BRANCH_DEV}
echo "${LOG_PREFIX}: Checking status..."
git status

echo "${LOG_PREFIX}: Starting test of the changes merged from the development barnch to the release barnch..."
run_test "MERGED"
