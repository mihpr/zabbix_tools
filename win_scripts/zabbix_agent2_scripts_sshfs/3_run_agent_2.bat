call variables2.bat

:: Run a self-compiled agent

%WIN_ZABBIX_REPO_ROOT%\bin\win64\zabbix_agent2.exe --config %WIN_ZABBIX_CONF_PATH% --foreground
