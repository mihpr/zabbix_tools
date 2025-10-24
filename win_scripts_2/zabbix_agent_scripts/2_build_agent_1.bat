call variables1.bat

set original_dir=%cd%

cd "%WIN_AGENT_TEMP_DIR%\zabbix*\build\win32\project"

set vcpkg="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static"

:: mingw32-make clean

:: Typical build
:: https://docs.microsoft.com/en-us/cpp/build/reference/running-nmake?view=msvc-170
:: nmake /K PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib
:: nmake PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib

:: Bild with precompiled OpenSSL
:: nmake PCREINCDIR="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static\include" PCRELIBDIR="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static\lib"


:: :: With OpenSSL static linking
:: SET SSL=TLS=openssl TLSINCDIR="C:\Program Files\OpenSSL-Win64\include" LIBS="Crypt32.lib" TLSLIB="C:\Program Files\OpenSSL-Win64\lib\vc\static\libcrypto64MT.lib" TLSLIB2="C:\Program Files\OpenSSL-Win64\lib\vc\static\libssl64MT.lib"
:: :: PRCRE
:: :: nmake /Wall -f Makefile PCREINCDIR=c:\git\vcpkg\installed\x64-windows-static\include PCRELIBDIR=c:\git\vcpkg\installed\x64-windows-static\lib
:: :: PRCRE2
:: nmake /Wall -f Makefile PCRE2INCDIR=c:\git\vcpkg\installed\x64-windows-static\include PCRE2LIBDIR=c:\git\vcpkg\installed\x64-windows-static\lib


:: With PCRE2 OpenSSL and curl installed from vcpkg
SET PCRE=PCRE2INCDIR="%vcpkg%\include" PCRE2LIBDIR="%vcpkg%\lib" 
SET SSL=TLS=openssl TLSINCDIR="%vcpkg%\include" LIBS="$(LIBS) Crypt32.lib" TLSLIB="%vcpkg%\lib\libcrypto.lib" TLSLIB2="%vcpkg%\lib\libssl.lib"
SET CURL=LIBS="$(LIBS) %vcpkg%\lib\libcurl.lib %vcpkg%\lib\zlib.lib Secur32.Lib" CFLAGS="$(CFLAGS) /D CURL_STATICLIB /D HAVE_LIBCURL -I %vcpkg%\include"
SET FLAGS=CFLAGS="$(CFLAGS) /D ZABBIX_VERSION_REVISION=%rev%_AMD64" RFLAGS="/D ZABBIX_VERSION_RC_NUM=64 /D ZABBIX_VERSION_REVISION=%rev%_AMD64"

nmake -f Makefile CPU=AMD64 %FLAGS% %PCRE% %SSL% %CURL% all 

cd "%original_dir%"
