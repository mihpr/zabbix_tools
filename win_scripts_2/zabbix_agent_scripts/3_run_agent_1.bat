call variables1.bat

set original_dir=%cd%
cd "%WIN_AGENT_TEMP_DIR%\zabbix*\bin\win64"
set zabbix_agentd_dir=%cd%
cd "%original_dir%"

:: Typical run
"%zabbix_agentd_dir%\zabbix_agentd.exe" --config "%WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf" --foreground
