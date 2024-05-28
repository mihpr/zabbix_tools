rm -rf /tmp/*.dump

# start this file from the zabbix_int repo

env-ctrl -down
env-ctrl -up
env-ctrl -pit
env-ctrl -pp