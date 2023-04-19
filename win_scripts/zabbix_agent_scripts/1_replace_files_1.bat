call variables1.bat

@RD /S /Q "C:\zabbix1"
mkdir "C:\zabbix1"

plink -batch -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP% cd %ZABBIX_REPO_ROOT%; make clean; make dist

pscp -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP%:%ZABBIX_REPO_ROOT%zabbix*.tar.gz C:\zabbix1

"C:\Program Files\7-Zip\7z.exe" x -y "C:\zabbix1\zabbix*.tar.gz" -o"C:\zabbix1\"
"C:\Program Files\7-Zip\7z.exe" x -y "C:\zabbix1\zabbix*.tar" -o"C:\zabbix1\"
