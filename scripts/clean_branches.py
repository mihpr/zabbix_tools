import os

# 1. Copy script to the repo.
# 2. Define branches to delete.
# 3. Run script: python clean_branches.py

branches_to_delete = (
  "feature/DEV-2560-6.5",
  "feature/DEV-2560-6.5-dbg01",
  "feature/DEV-3672-6.5-dbg03",
  "feature/DEV-3672-6.5-dbg04",
  "feature/DEV-3672-7.0-2",
  "feature/DEV-3672-7.0-dbg04",
  "feature/DEV-3672-7.0-test01",
  "feature/DEV-3672-7.1-2",
  "feature/DEV-3672-7.2-2",
  "feature/ZBX-24455-7.0",
  "feature/ZBX-24601-7.0",
  "feature/ZBXNEXT-7930-6.5",
  "feature/ZBXNEXT-9218-7.0",
  "feature/ZBXNEXT-9293-6.0",
  "feature/ZBXNEXT-9293-6.4",
  "feature/ZBXNEXT-9293-7.0",
  "feature/ZBXNEXT-9293-7.1",
  "feature/ZBXNEXT-9293-7.2",
)

for branch in branches_to_delete:
    os.system("git branch -D %s" % branch)

print("Branches after deletion:")
os.system("git branch")