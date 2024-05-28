#!/bin/bash

# edit config in int_tests_permissions_grant.sh

INT_TESTS_HOME='/home/mikhail/git/zabbix_int'
INT_TESTS_LOG='/tmp/int_tests.log'

cd $INT_TESTS_HOME
rm $INT_TESTS_LOG
int_tests_run.sh > ${INT_TESTS_LOG} 2>&1