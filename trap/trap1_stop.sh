# Congigure item having
# Type: Zabbix trapper
# Key: trap1
# Type: text

# Configure trigger having:
# Expression: {Zabbix server:trap1.last()}="problem start"
zabbix_sender -z localhost -p 10051 -s "Zabbix server" -k trap1 -o "problem stop"
