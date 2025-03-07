call variables1.bat

set original_dir=%cd%
cd "%WIN_AGENT_TEMP_DIR%\zabbix*\bin\win64"
set zabbix_agentd_dir=%cd%
cd "%original_dir%"


taskkill /IM zabbix* /F

:: Typical run
"%zabbix_agentd_dir%\zabbix_agentd.exe" --config "%WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf" --foreground

::"C:\Users\mikhail\Downloads\DrMemory-Windows-2.2.0-1\bin\drmemory.exe" -- %zabbix_agentd_dir%\zabbix_agentd.exe


::"C:\Program Files (x86)\Dr. Memory\bin\drmemory.exe" -- %zabbix_agentd_dir%\zabbix_agentd.exe

::"C:\Program Files (x86)\Dr. Memory\bin\drmemory.exe" -ignore_kernel -logdir ./drememory_log -- %zabbix_agentd_dir%\zabbix_agentd.exe -c %WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf -f
::"C:\Users\mikhail\Downloads\DrMemory-Windows-2.2.0-1\bin\drmemory.exe" -ignore_kernel -logdir ./drememory_log -debug -leaks_only -no_count_leaks -no_track_allocs -- %zabbix_agentd_dir%\zabbix_agentd.exe -c %WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf -f



::"C:\Users\mikhail\Downloads\DrMemory-Windows-2.2.0-1\dynamorio\bin64\drrun.exe" -logdir ./drememory_log -- %zabbix_agentd_dir%\zabbix_agentd.exe -c %WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf -f
::"C:\Program Files (x86)\Dr. Memory\dynamorio\bin64\drrun.exe" -logdir ./drememory_log -- %zabbix_agentd_dir%\zabbix_agentd.exe -c %WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf -f



::"C:\Program Files (x86)\Dr. Memory\bin\drmemory.exe" -ignore_kernel -logdir ./drememory_log -- %zabbix_agentd_dir%\zabbix_agentd.exe -t vfs.fs.get
::"C:\Users\mikhail\Downloads\DrMemory-Windows-2.2.0-1\bin\drmemory.exe" -ignore_kernel -logdir ./drememory_log -- %zabbix_agentd_dir%\zabbix_agentd.exe -t vfs.fs.get


::%zabbix_agentd_dir%\zabbix_agentd.exe -t vfs.fs.get

::%zabbix_agentd_dir%\zabbix_agentd.exe -c %WIN_AGENT_CONF_DIR%\zabbix_agentd.win.conf -f


::"C:\Users\mikhail\Downloads\DrMemory-Windows-2.2.0-1\bin\drmemory.exe" -ignore_kernel -logdir ./drememory_log -- %zabbix_agentd_dir%\zabbix_agentd.exe -p
