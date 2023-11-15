#!/usr/bin/env bash

# 1. make sure there is no unsaved work
# 2. execute: git reset --hard; git clean -dfx
# 3. set BRANCH_DEV and BRANCH_RELEASE variables below
# 4. run


########################################################################################################################

# Configuration section

BRANCH_DEV="feature/ZBX-23580-6.0"
BRANCH_RELEASE="release/6.0"

# DB_KEY="--with-mysql"
DB_KEY="--with-postgresql"

########################################################################################################################

start=$(date +%s)
START_DATE=$(date '+%Y-%m-%d %H:%M:%S %z')

# for clang from Aleksej Shestakov
export CC=clang
export CC=clang-12
export CFLAGS="-Wall -Wextra -Wenum-conversion -g -O2 -fsanitize=leak,address -Wcast-align -Wsign-conversion -Wcast-qual -Wconversion"
export LDFLAGS="-fsanitize=leak,address"

LOG_DIR="${HOME}/iwyu_log/${START_DATE}/"
echo $LOG_DIR
mkdir -p "${LOG_DIR}"

warnings_check_compile() {
	LOG_FILE="${LOG_DIR}log_warnings_${1}.txt"

	sudo git clean -dfx
	sh ./bootstrap.sh

	sh ./configure $DB_KEY --enable-server --enable-agent --enable-proxy --with-libcurl --with-libxml2 --with-openssl --enable-ipv6 --with-net-snmp

	make -j 1 2>&1 | tee "${LOG_FILE}"
}

iwyu_compile() {
	LOG_FILE_IWYU=${LOG_DIR}log_iwyu_${1}.txt
	LOG_FILE_MAKE=${LOG_DIR}log_iwyu_make_${1}.txt

	git clean -dfx
	sh ./bootstrap.sh
	sh ./configure $DB_KEY --enable-server --enable-agent --enable-proxy --with-libcurl --with-libxml2 --with-openssl --enable-ipv6 --with-net-snmp
	CC=include-what-you-use make --keep-going --environment-overrides 2>&1 | tee "${LOG_FILE_IWYU}"

	make -j 1 2>&1 | tee "${LOG_FILE_MAKE}"
}

git fetch

branch_release_test="${BRANCH_RELEASE}_test"
branch_dev_test="${BRANCH_DEV}_test"

git checkout ${BRANCH_DEV}
git pull
git checkout ${BRANCH_RELEASE}
git pull

git branch -D ${branch_release_test}
git branch -D ${branch_dev_test}

git checkout -b ${branch_release_test}
git checkout -b ${branch_dev_test}

git merge --squash ${BRANCH_DEV}
git commit -m "simulated merge"

git checkout ${branch_release_test}
warnings_check_compile 0
iwyu_compile 0

git checkout ${branch_dev_test}
warnings_check_compile 1
iwyu_compile 1

END_DATE=$(date '+%Y-%m-%d %H:%M:%S %z')

echo "START_DATE: ${START_DATE}"
echo "END_DATE:   ${END_DATE}"

end=$(date +%s)
runtime=$((end-start))
rmin=$(($runtime / 60))
rsec=$(($runtime % 60))
echo "Runtime duration: $(printf %02d $rmin):$(printf %02d $rsec) mm:ss"
