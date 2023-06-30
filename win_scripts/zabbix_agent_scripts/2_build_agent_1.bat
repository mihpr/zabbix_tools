call variables1.bat

cd "c:\zabbix1\zabbix*\build\win32\project"

mingw32-make clean
REM https://docs.microsoft.com/en-us/cpp/build/reference/running-nmake?view=msvc-170
REM nmake /K PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib
nmake PCRE2INCDIR=C:\pcre2-10.39-install\include PCRE2LIBDIR=C:\pcre2-10.39-install\lib

rem dir "C:\zabbix1\zabbix-%version%\bin\win64"

cd "C:\zabbix_agent_scripts"
