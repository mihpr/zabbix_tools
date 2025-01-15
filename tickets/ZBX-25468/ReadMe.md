- Choose one of the trends_v3_psycopg2.py or trends_v4_zabbix_utils.py script and copy it to any convenient location from here https://github.com/mihpr/zabbix_tools/blob/master/tickets/ZBX-25468/

Each of the scripts reads trends from the database and all exported files in the given ExportDir. It tries to match each entry in database to an entry in JSON file and shows the results.

  - trends_v3_psycopg2.py uses psycopg to directly connect to the database to read "trends" and "trends_uint". Before the first run, it might need installation of Python module that works with the database. Quick installation with pip: https://www.psycopg.org/docs/install.html#quick-install
  - trends_v4_zabbix_utils.py uses python-zabbix-utils to read the trends data using "trend.get" API method. Before the first run, it might need installation of python-zabbix-utils https://github.com/zabbix/python-zabbix-utils

Limitations: the script does not lock database and files when it reads them.

- Configure the script by setting variables in the upper part of it.

- Important: disable any custom scripts, which work with JSON export files, to exclude any problems caused by custom scripting.

- If possible, increase ExportFileSize option in zabbix_server.conf. The exact value is at your discretion. The larger the value is, the longer observation window it provides to find regularities if of the problem if there are any.

- The script may be run from time to time to get updated results:

```
python3 trends_v3_psycopg2.py
```
or
```
python3 trends_v4_zabbix_utils.py
```
or
```
python3 trends_v3_psycopg2.py > out.txt
```
or
```
python3 trends_v4_zabbix_utils.py > out.txt
```
