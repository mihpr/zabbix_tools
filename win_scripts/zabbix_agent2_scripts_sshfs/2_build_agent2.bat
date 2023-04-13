:: ################################################################################
:: Worked from a simple cmd termonal, not only from the "x64 Native Tools Command Prompt for VS 2017 RC"
:: ################################################################################

:: In case the agent is built from git repository in place, %ZABBIX_REPO_ROOT%\include\common\config.h possibly must be renamed or removed.
:: However, some other experiments show that it is not needed.

:: The following command fixes problems with privileges on Linux machine.
:: chmod -R a+rwx $ZABBIX_REPO_ROOT

call variables2.bat

set original_drive=%cd:~0,2%
set original_dir=%cd%

cd "c:\zabbix2\zabbix-%ZABBIX_VERSION%\build\mingw"
%ZABBIX_REPO_ROOT:~0,2%
cd "%ZABBIX_REPO_ROOT%\build\mingw"
dir

mingw32-make clean
:: With PCRE 1 and OPENSSL
mingw32-make PCRE=c:\go-libs\pcre64 OPENSSL=c:\go-libs\openssl64 RFLAGS="-DZABBIX_VERSION_RC_NUM=64"
:: mingw32-make ARCH=%ARCH% PCRE="C:\go-libs\pcre%CPU%" OPENSSL="C:\go-libs\openssl%CPU%" RFLAGS="-DZABBIX_VERSION_RC_NUM=%CPU%"
:: mingw32-make PCRE=PCRE_DIR OPENSSL=OPENSSL_DIR

%original_drive%
cd %original_dir%