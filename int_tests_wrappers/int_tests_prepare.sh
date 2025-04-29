# rm -rf /tmp/*.dump
rm -rf /tmp/*

# start this file from the zabbix_int repo

env-ctrl -down

# copy cfg for agent 2
cp ${PWD}/src/go/conf/zabbix_agent2.conf ${PWD}/conf/zabbix_agent2.conf

# copy cfg and binary for testAgentJsonProtocol test
cp ${PWD}/conf/zabbix_agentd.conf ${PWD}/conf/zabbix_agentd_3.0.conf
cp ${PWD}/sbin/zabbix_agentd ${PWD}/sbin/zabbix_agentd_3.0

env-ctrl -up
env-ctrl -pit
env-ctrl -pp