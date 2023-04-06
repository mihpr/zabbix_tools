"""

This script downloads fping sources from the official website and compiles them.

Instructions:

1. Put this file into an empty directory, where you want.
2. Edit versions tuple below in case it is needed.
3. Run it from a Linux bash shell:
        python3 fping_build.py

Fping changelog:

Changelog  since fping 4.0: https://github.com/schweikert/fping/blob/develop/CHANGELOG.md
Changelog before fping 4.0: https://github.com/schweikert/fping/blob/develop/doc/CHANGELOG.pre-v4

Known limitations:

fping-3.0 built by this script is known to be unable to run in non privileged mode.

IPv6 seems to be supported in fping 3.x versions starting from fping-3.3:
Add --enable-ipv4 and --enable-ipv6 options to configure (Niclas Zeising)

Before fping 4.0, there were different binaries for IPv4 and IPv6: fping, fping6.
Since fping 4.0, fping and fping6 are unified into one binary fping.

"""

import requests
import os
import datetime

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
LOG_FILE_PATH = os.path.join(CURRENT_DIR, "log.txt")
PFING_DIST_URL = "https://fping.org/dist/"

bin_dir = os.path.join(CURRENT_DIR, "bin")
if not os.path.exists(bin_dir):
    os.makedirs(bin_dir)

# N.B. A trailing comma must be placed in case a Python tuple contains only one value:
# Example: versions("3.0",)
versions = ("3.0", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "3.10", "3.11", "3.12", "3.13", "3.14", "3.15", "3.16", "4.0", "4.1", "4.2", "4.3", "4.4",  "5.0", "5.1",)

with open(LOG_FILE_PATH, 'w') as logfile:
    time_start = datetime.datetime.now()
    def log(s):
        logfile.write("%s    %s\n" % (datetime.datetime.now(), s))

    log("Build started.")
    for version in versions:
        try:
            fping_bin_file_path = os.path.join(bin_dir, "fping-%s" % version)
            if os.path.exists(fping_bin_file_path):
                os.remove(fping_bin_file_path)


            fping6_bin_file_path = os.path.join(bin_dir, "fping6-%s" % version)
            if os.path.exists(fping6_bin_file_path):
                os.remove(fping6_bin_file_path)

            output_dir = os.path.join(CURRENT_DIR, "output", "fping-%s" % version)
            if os.path.exists(output_dir):
                os.system("rm -rf %s" % output_dir)
            os.makedirs(output_dir)

            fping_archive_file = "fping-%s.tar.gz" % version
            dest_fping_archive_file_path = os.path.join(output_dir, fping_archive_file)

            url = PFING_DIST_URL + fping_archive_file
            r = requests.get(url, allow_redirects=True)
            open(dest_fping_archive_file_path, 'wb').write(r.content)

            os.system("cd %s; tar -xzvf %s" % (output_dir, fping_archive_file))
            build_dir = os.path.join(output_dir, "fping-%s" % version)
            os.system("cd %s; ./configure --prefix=${PWD} --exec-prefix=${PWD} --enable-ipv4 --enable-ipv6; make; make install" % (build_dir,))
            
            os.system("cp %s %s" % (os.path.join(build_dir, "sbin", "fping"), fping_bin_file_path))
            os.system("cd %s; sudo setcap cap_net_raw+ep fping-%s" % (bin_dir, version))

            if os.path.exists(os.path.join(build_dir, "sbin", "fping6")):
                fping6_is_separate_binary = True
            else:
                fping6_is_separate_binary = False
                
            if fping6_is_separate_binary:
                os.system("cp %s %s" % (os.path.join(build_dir, "sbin", "fping6"), fping6_bin_file_path))
                os.system("cd %s; sudo setcap cap_net_raw+ep fping6-%s" % (bin_dir, version))

            if not os.path.exists(fping_bin_file_path):
                raise Exception("enexpected error, destination binary file %s is absent" % fping_bin_file_path)

            if fping6_is_separate_binary and not os.path.exists(fping6_bin_file_path):
                raise Exception("enexpected error, destination binary file %s is absent" % fping6_bin_file_path)

            log("fping-%s OK" % version)
        except Exception as e:
            log("fping-%s FAILED: %s" % (version, e))

    log("Build finished.")
    time_end = datetime.datetime.now()
    duration = time_end - time_start
    s = "Total build duration (h:mm:ss:microseconds): %s" % duration
    log(s)

    print ("\n\n\n---===== Build finsihed =====---\n")
    print(s)


# Testing

print ("\n\n\n---===== Testing =====---\n")
for version in versions:
    cmd = "cd %s; ./fping-%s 8.8.8.8" % (bin_dir, version)
    # print (cmd)
    print ("Testing fping-%s..." % version)
    os.system(cmd)
