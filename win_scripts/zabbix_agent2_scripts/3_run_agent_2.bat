call variables2.bat

:: Run a self-compiled agent

set original_dir=%cd%
cd "C:\zabbix2\zabbix*\bin\win64
set zabbix_agent2_dir=%cd%
cd %original_dir%

%zabbix_agent2_dir%\zabbix_agent2.exe --config "C:\zabbix_agent2_scripts\conf\zabbix_agent2.win.conf" --foreground

