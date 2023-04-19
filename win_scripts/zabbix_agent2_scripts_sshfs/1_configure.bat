call variables2.bat

plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %LINUX_ZABBIX_REPO_ROOT%; git clean -dfx
plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %LINUX_ZABBIX_REPO_ROOT%; git checkout HEAD %LINUX_MAKEFILE_FOR_WIN_PATH%
::plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %LINUX_ZABBIX_REPO_ROOT%; ./bootstrap.sh; ./configure --enable-agent2 --with-openssl --prefix=$(pwd)
plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %LINUX_ZABBIX_REPO_ROOT%; sed -i 's/go build/go build -buildvcs="false"/g' %LINUX_MAKEFILE_FOR_WIN_PATH%


