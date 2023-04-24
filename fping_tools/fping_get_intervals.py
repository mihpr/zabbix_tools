#!/usr/bin/python3
import os

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
bin_dir = os.path.join(CURRENT_DIR, "bin")
versions = ("2.4", "3.0", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "3.10", "3.11", "3.12", "3.13", "3.14", "3.15", "3.16", "4.0", "4.1", "4.2", "4.3", "4.4",  "5.0", "5.1",)
intervals = (0, 1, 10)
dst = "127.0.0.1"

run_with_sudo = False

for version in versions:
    fping_bin_file_path = os.path.join(bin_dir, "fping-%s" % version)

    print("\n==================== fping-%s ====================\n" % version)

    if run_with_sudo == True:
        sudo="sudo "
    else:
        sudo=""

    for i in intervals:
        print("\n---------- interval: %d ----------\n" % i)
        command = "%s%s -c1 -t50 -i%u %s" % (sudo, fping_bin_file_path, i, dst)
        print("%s\n" % command)
        os.system(command)