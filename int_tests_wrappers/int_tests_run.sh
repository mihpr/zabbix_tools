#!/bin/bash

# edit config in int_tests_permissions_grant.sh
# start this file from the zabbix_int repo

git clean -dfx
git status
git show

rm /tmp/zabbix*
rm -rf /tmp/data-sources
rm -rf /tmp/failed


sh $(which int_tests_permissions_grant.sh)

env-ctrl -down
env-ctrl -up
env-ctrl -pit
env-ctrl -pp

# copy cfg for agent 2
cp ${PWD}/src/go/conf/zabbix_agent2.conf ${PWD}/conf/zabbix_agent2.conf

# copy cfg and binary for testAgentJsonProtocol test
cp ${PWD}/conf/zabbix_agentd.conf ${PWD}/conf/zabbix_agentd_3.0.conf
cp ${PWD}/sbin/zabbix_agentd ${PWD}/sbin/zabbix_agentd_3.0


env-ctrl -ti IntegrationTests

# env-ctrl -ti testDiscoveryRules

# env-ctrl -ti testGoAgentDataCollection
# env-ctrl -ti testItemTimeouts
# env-ctrl -ti testUserParametersReload
# env-ctrl -ti testEscalations
# a short test that passes
# env-ctrl -ti testUserMacrosInItemNames
# env-ctrl -ti testAgentJsonProtocol
# env-ctrl -ti testItemTimeouts

echo "Done: running integration tests"