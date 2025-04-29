import os

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
bin_dir = os.path.join(CURRENT_DIR, "bin")

# LOG_FILE_PATH=os.path.join(CURRENT_DIR, "fping_log.txt")

versions = ("3.0", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "3.10", "3.11", "3.12", "3.13", "3.14", "3.15", "3.16", "4.0", "4.1", "4.2", "4.3", "4.4",  "5.0", "5.1", "5.2")
# versions = ("2.4", "3.1", "3.10", "3.11", "3.16", "4.0","4.4", "5.0", "5.1",)

for version in versions:
    fping_bin_file_path = os.path.join(bin_dir, "fping-%s" % version)

    print("\n--------------------------------------------------------------------------------\n")
    print("fping-%s" % version)

    if version == "2.4":
        sudo = "sudo "
    else:
        sudo = ""

    # command = "%s%s -C3 -p500 -b1000 -t200 -i10 192.168.202.10" % (sudo, fping_bin_file_path,)
    command = "%s%s -C3 -p500 -b1000 -t200 -i10 1.1.1.1" % (sudo, fping_bin_file_path,)
    print("%s\n" % command)
    os.system(command)