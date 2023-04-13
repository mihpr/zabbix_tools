call variables2.bat

@RD /S /Q "C:\zabbix2"
mkdir "C:\zabbix2"

pscp -pw %LINUX_MACHINE_PASSWORD% %LINUX_MACHINE_USER%@%LINUX_MACHINE_IP%:%ZABBIX_REPO_ROOT%zabbix*.tar.gz C:\zabbix2

"C:\Program Files\7-Zip\7z.exe" x -y "C:\zabbix2\zabbix*.tar.gz" -o"C:\zabbix2\"
"C:\Program Files\7-Zip\7z.exe" x -y "C:\zabbix2\zabbix*.tar" -o"C:\zabbix2\"
