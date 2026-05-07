start zabbix_agent2.exe --config conf\zabbix_agent2_000.win.conf --foreground
echo Starting agent 0
timeout /t 1 /nobreak >nul

start zabbix_agent2.exe --config conf\zabbix_agent2_001.win.conf --foreground
echo Starting agent 1
timeout /t 1 /nobreak >nul

start zabbix_agent2.exe --config conf\zabbix_agent2_002.win.conf --foreground
echo Starting agent 2
timeout /t 1 /nobreak >nul

