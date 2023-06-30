call variables1.bat

plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %ZABBIX_REPO_ROOT%; git clean -dfx; ./bootstrap.sh; ./configure --enable-agent --prefix=$(pwd)
