:: Common
set REPO=zabbix_agent_win

:: Win
set WIN_ZABBIX_REPO_ROOT=z:\git\%REPO%
set WIN_PCRE_DIR=c:\go-libs\pcre64
set WIN_OPENSSL_DIR=c:\go-libs\openssl64
set WIN_ZABBIX_CONF_PATH=c:\zabbix_agent2_scripts_sshfs\conf\zabbix_agent2.win.conf


:: Linux
set LINUX_ZABBIX_REPO_ROOT=/home/mikhail/git/%REPO%
set LINUX_MAKEFILE_FOR_WIN_PATH=%LINUX_ZABBIX_REPO_ROOT%/src/go/Makefile.am

set LINUX_MACHINE_USER=mikhail
set LINUX_MACHINE_IP=192.168.56.201
set LINUX_MACHINE_PASSWORD="password"
