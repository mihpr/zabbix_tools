:: ################################################################################
:: Worked from a simple cmd termonal, not only from the "x64 Native Tools Command Prompt for VS 2017 RC"
:: ################################################################################

:: C:\mingw64\bin\ must be in PATH for triplets containing mingw

call ..\za_common\variables_common.bat

set original_dir=%cd%

cd "%WIN_AGENT2_TEMP_DIR%\zabbix*\build\mingw"

:: mingw32-make clean

:: Legacy with PCRE 1 and OPENSSL
::mingw32-make PCRE=c:\go-libs\pcre64 OPENSSL=c:\go-libs\openssl64 RFLAGS="-DZABBIX_VERSION_RC_NUM=64"

:: With vcpkg
set vckpg=%WIN_VCPKG_ROOT_DIR%\installed\x64-mingw-static

set CGO_LDFLAGS="-lCrypt32"
:: With PCRE 1 and OpenSSL installed with vcpkg
:: mingw32-make PCRE=%vckpg% OPENSSL=%vckpg% RFLAGS="-DZABBIX_VERSION_RC_NUM=64"

:: With PCRE 2 and OpenSSL installed with vcpkg
mingw32-make PCRE2=%vckpg% OPENSSL=%vckpg% RFLAGS="-DZABBIX_VERSION_RC_NUM=64"

cd %original_dir%
