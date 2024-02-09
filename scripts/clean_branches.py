import os

# 1. Copy script to the repo.
# 2. Define branches to delete.
# 3. Run script: python clean_branches.py

branches_to_delete = (
    "feature/DEV-1224-6.0",
    "feature/ZBX-1224-6.0",
    "feature/ZBXNEXT-1224-6.0",
)

for branch in branches_to_delete:
    os.system("git branch -D %s" % branch)

print("Branches afte deletion:")
os.system("git branch")