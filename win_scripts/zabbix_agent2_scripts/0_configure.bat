call variables2.bat

::plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %ZABBIX_REPO_ROOT%; git clean -dfx; ./bootstrap.sh; ./configure --enable-agent --enable-agent2 --with-openssl --prefix=$(pwd); make dist
::plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %ZABBIX_REPO_ROOT%; git clean -dfx; ./bootstrap.sh; ./configure --enable-agent2 --prefix=$(pwd); make dist
plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %ZABBIX_REPO_ROOT%; git clean -dfx; ./bootstrap.sh; ./configure --enable-agent2 --prefix=$(pwd)
::plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %ZABBIX_REPO_ROOT%; make clean; make dist

