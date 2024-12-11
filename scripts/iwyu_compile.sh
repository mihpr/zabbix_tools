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
# - Make sure the [Settings] below are correct.
# - Run the script from the Zabbix repository (with no command line parameters).
# A new folder will be created for logs during the test run.
# - Compare logs with any text file comparion tool you like.

STARTED_AT=$(date +"%Y-%m-%d_%H-%M-%S")

# ---=== [Settings] ===---
BRANCH_DEV="feature/ZBX-25672-7.0"
BRANCH_RELEASE="release/7.0"
LOG_DIR="${HOME}/scripts/iwyu_log/${STARTED_AT}/"
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
echo "${LOG_PREFIX}: Started at ${STARTED_AT}"
echo "${LOG_PREFIX}: Creating log dir..."
mkdir -p ${LOG_DIR}
echo "${LOG_PREFIX}: Cleaning uncommitted changes..."
git reset --hard
git clean -dfx
echo "${LOG_PREFIX}: Fetching from remote (with no merging)..."
git fetch
echo "${LOG_PREFIX}: Checking out the development branch..."
git checkout ${BRANCH_DEV}
echo "${LOG_PREFIX}: Pulling the development branch..."
git pull
echo "${LOG_PREFIX}: Checking out the release branch..."
git checkout ${BRANCH_RELEASE}
echo "${LOG_PREFIX}: Pulling the release branch..."
git pull

# ---=== [Test RELEASE] ===---

echo "${LOG_PREFIX}: Starting test of the release branch..."
run_test "RELEASE"

# ---=== [Test MERGED] ===---

# Test the changes merged from development branch to the release branch
echo "${LOG_PREFIX}: Cleaning uncommitted changes..."
git reset --hard
git clean -dfx
echo "${LOG_PREFIX}: Merging the changes from development branch to the release branch with no commit..."
git merge --no-commit ${BRANCH_DEV}
echo "${LOG_PREFIX}: Checking status..."
git status

echo "${LOG_PREFIX}: Starting test of the changes merged from the development branch to the release branch..."
run_test "MERGED"

# Finalizing after tests
FINISHED_AT=$(date +"%Y-%m-%d_%H-%M-%S")
echo "${LOG_PREFIX}: Started at  ${STARTED_AT}"
echo "${LOG_PREFIX}: Finished at ${FINISHED_AT}"
