call variables1.bat

REM Run a self-compiled agent
::C:\zabbix1\zabbix-%version%\bin\win64\zabbix_agentd.exe --config "C:\zabbix_agent_scripts\zabbix_agentd.win.conf" --foreground
::C:\zabbix1\zabbix-%version%\bin\win64\zabbix_agentd.exe --config "C:\zabbix_agent_scripts\zabbix_agentd.win.conf" -h

REM C:\zabbix1\bin\zabbix_agentd.exe --config "C:\zabbix_agent_scripts\zabbix_agentd.win.conf" --foreground


set original_dir=%cd%
cd "C:\zabbix1\zabbix*\bin\win64
set zabbix_agentd_dir=%cd%
cd %original_dir%

%zabbix_agentd_dir%\zabbix_agentd.exe --config "C:\zabbix_agent_scripts\conf\zabbix_agentd.win.conf" --foreground