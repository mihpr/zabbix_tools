call variables1.bat

set original_dir=%cd%

cd "%WIN_AGENT_TEMP_DIR%\zabbix*\build\win32\project"

mingw32-make clean

REM Typical build
REM https://docs.microsoft.com/en-us/cpp/build/reference/running-nmake?view=msvc-170
REM nmake /K PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib
@REM nmake PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib

REM Bild with precompiled OpenSSL
nmake PCREINCDIR="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static\include" PCRELIBDIR="%WIN_VCPKG_ROOT_DIR%\installed\x64-windows-static\lib"

cd "%original_dir%"
