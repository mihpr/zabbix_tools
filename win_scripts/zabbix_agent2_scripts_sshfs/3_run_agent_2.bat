call variables2.bat

:: Run a self-compiled agent

@echo Started: %date% %time%

%ZABBIX_REPO_ROOT%\bin\win64\zabbix_agent2.exe --config %ZABBIX_CONF_PATH%
:: %ZABBIX_REPO_ROOT%\bin\win64\zabbix_agent2.exe -help
