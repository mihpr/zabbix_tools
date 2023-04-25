#!/usr/bin/python3
import os
import subprocess
import pprint

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
bin_dir = os.path.join(CURRENT_DIR, "bin")
VERSIONS = ("2.4", "3.0", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "3.10", "3.11", "3.12", "3.13", "3.14", "3.15", "3.16", "4.0", "4.1", "4.2", "4.3", "4.4",  "5.0", "5.1",)
#VERSIONS = ("4.0", "4.1", "4.2", "4.3", "4.4",  "5.0", "5.1",)
INTERVALS = (0, 1, 10)
dst = "127.0.0.1"

RUN_WITH_SUDO = False

if RUN_WITH_SUDO:
    sudo="sudo "
else:
    sudo=""

MODE_GET_INTERVAL_OPTION_SUBPROCESS = 0  # run fping in way similar to get_interval_option() in src/libs/zbxicmpping/icmpping.c
MODE_GET_INTERVAL_OPTION_SYSTEM     = 1  # run fping in way similar to get_interval_option() in src/libs/zbxicmpping/icmpping.c
MODE_GET_DEFAULT_INTERVAL           = 2  # get default intervals from help messages

# Set mode here
MODE = MODE_GET_INTERVAL_OPTION_SYSTEM

pp = pprint.PrettyPrinter()

for version in VERSIONS:
    fping_bin_file_path = os.path.join(bin_dir, "fping-%s" % version)

    print("\n==================== fping-%s ====================\n" % version)

    if MODE in (MODE_GET_INTERVAL_OPTION_SUBPROCESS, MODE_GET_INTERVAL_OPTION_SYSTEM):
        for i in INTERVALS:

            print("\n---------- interval: %d ----------\n" % i)
            cmd = "%s%s -c1 -t50 -i%u %s" % (sudo, fping_bin_file_path, i, dst)

            if MODE == MODE_GET_INTERVAL_OPTION_SUBPROCESS:
                ret = None
                try:
                    ret = subprocess.run(cmd, shell=True, check=True, capture_output=True)
                except Exception as e:
                    print("Exception:", e)

                print("---=== subprocess.CompletedProcess: ===---")
                if ret is not None:
                    print("args       :", ret.args)
                    print("returncode :", ret.returncode)
                    print("stdout     :", ret.stdout)
                    print("stderr     :", ret.stderr)
                else:
                    print("ret is None")
            elif MODE == MODE_GET_INTERVAL_OPTION_SYSTEM:
                print("%s\n" % cmd)
                print("<BEGIN>")
                os.system(cmd)
                print("<END>")
    else:
            cmd = '%s%s -h | grep interval | grep default' % (sudo, fping_bin_file_path)
            print("%s\n" % cmd)
            os.system(cmd)
