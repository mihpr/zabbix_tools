call variables1.bat

set original_dir=%cd%

cd "%WIN_AGENT_TEMP_DIR%\zabbix*\build\win32\project"

:: mingw32-make clean

:: Typical build
:: https://docs.microsoft.com/en-us/cpp/build/reference/running-nmake?view=msvc-170
:: nmake /K PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib
:: nmake PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib

:: Bild with precompiled OpenSSL
:: nmake PCREINCDIR="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static\include" PCRELIBDIR="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static\lib"


:: With OpenSSL tatic linking
SET SSL=TLS=openssl TLSINCDIR="C:\Program Files\OpenSSL-Win64\include" LIBS="Crypt32.lib" TLSLIB="C:\Program Files\OpenSSL-Win64\lib\vc\static\libcrypto64MT.lib" TLSLIB2="C:\Program Files\OpenSSL-Win64\lib\vc\static\libssl64MT.lib"
:: nmake /Wall -f Makefile PCREINCDIR=c:\git\vcpkg\installed\x64-windows-static\include PCRELIBDIR=c:\git\vcpkg\installed\x64-windows-static\lib
nmake /Wall -f Makefile PCRE2INCDIR=c:\git\vcpkg\installed\x64-windows-static\include PCRE2LIBDIR=c:\git\vcpkg\installed\x64-windows-static\lib

cd "%original_dir%"
