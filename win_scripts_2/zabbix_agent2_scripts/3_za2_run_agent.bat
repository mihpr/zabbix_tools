echo %WIN_AGENT2_ROOT_DIR%

call ..\za_common\variables_common.bat

set original_dir=%cd%
cd "%WIN_AGENT2_TEMP_DIR%\zabbix*\bin\win64"
set zabbix_agent2_bin=%cd%
cd "%original_dir%"

%zabbix_agent2_bin%\zabbix_agent2.exe --config "%WIN_AGENT2_CONF_DIR%\zabbix_agent2.win.conf" --foreground
