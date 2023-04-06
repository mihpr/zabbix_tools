:: ################################################################################
:: Worked from a simple cmd termonal, not only from the "x64 Native Tools Command Prompt for VS 2017 RC"
:: ################################################################################

call variables2.bat

set original_dir=%cd%

cd "c:\zabbix2\zabbix*\build\mingw"

mingw32-make clean
:: With PCRE 1 and OPENSSL
mingw32-make PCRE=c:\go-libs\pcre64 OPENSSL=c:\go-libs\openssl64 RFLAGS="-DZABBIX_VERSION_RC_NUM=64"

cd %original_dir%
