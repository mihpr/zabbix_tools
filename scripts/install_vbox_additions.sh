#!/usr/bin/env bash

# 1. Insert VirualBox additions disk. Gust shutdown might be required.
# 2. Run the script.
# 3. Remove VirualBox additions disk.

sudo mount /dev/cdrom /mnt/
cd /mnt/
sudo ./VBoxLinuxAdditions.run
cd -
sudo umount /mnt
