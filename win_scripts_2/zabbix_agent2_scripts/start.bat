set agent2_path="C:\zabbix_agent2\tmp\zabbix-7.0.26\bin\win64\zabbix_agent2.exe"
set config_path="C:\zabbix_agent2\conf\zabbix_agent2.win.conf"


::C:\zabbix_agent2\tmp\zabbix-7.0.26\bin\win64\zabbix_agent2.exe --config C:\zabbix_agent2\conf\zabbix_agent2.win.conf --foreground

%agent2_path% --config %config_path% --foreground