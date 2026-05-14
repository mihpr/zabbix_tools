import os
import re
import sys

###
# Run from the directory with the Zabbix repo.
# Example:
# ~/git/zabbix$ python3 ~/git/zabbix_tools/py_scripts/db_max_ver_update.py

### constants
DB_TYPE_MYSQL = "MySQL"
DB_TYPE_TIMESCALE = "TimescaleDB"

### settings

# (release branch, feature branch suffix)
git_branch_sfx = (
    ("release/6.0", "6.0"),
    ("release/7.0", "7.0"),
    ("release/7.4", "7.4"),
    ("master",      "7.5")
)

jira    = "ZBXNEXT-10618"
db_type = DB_TYPE_TIMESCALE
author  = "mprihodko"

if db_type == DB_TYPE_MYSQL:
    new_db_max_version_str_in_commit_msg = "9.7"
    new_db_max_version_str_in_h_file     = "9.7.x"
    new_db_max_version_int  = "90799"
elif db_type == DB_TYPE_TIMESCALE:
    new_db_max_version_str_in_commit_msg = "2.27"
    new_db_max_version_str_in_h_file     = new_db_max_version_str_in_commit_msg
    new_db_max_version_int  = "22799"
else:
    print(f"Error: unsupported db_type '{db_type}'")
    sys.exit(1)

### functions

def commit_msg_build():
    if db_type == DB_TYPE_MYSQL:
        components = 'A......PS.'
    elif db_type == DB_TYPE_TIMESCALE:
        components = 'A.......S.'

    return "{} [{}] updated maximum supported {} version to {}".format(components, jira, db_type, new_db_max_version_str_in_commit_msg)

def replace_define_int(content: str, define: str, new_value: int) -> str:
    """
    Replace a numeric value of a #define constant in a C header file content.

    Example:
        new_content = replace_define_int(content, "ZBX_MYSQL_MAX_VERSION", 50750)
        # Returns: C header file content with ZBX_MYSQL_MAX_VERSION replaced.
    """
    return re.sub(
        rf"(#define {define}\s+)\d+",
        rf"\g<1>{new_value}",
        content
    )

def replace_define_str(content: str, define: str, new_value: str) -> str:
    """
    Replace a string value of a #define constant in a C header file content.

    Example:
        new_content = replace_define_str(content, "ZBX_MYSQL_MAX_VERSION_STR", "5.7.50")
        # Returns: C header file content with ZBX_MYSQL_MAX_VERSION_STR replaced.
    """
    return re.sub(
        rf'(#define {define}\s+)"[^"]+"',
        rf'\g<1>"{new_value}"',
        content
    )

def changelog_create(commit_msg):
    if db_type == DB_TYPE_MYSQL:
        components = 'A......PS.'
    elif db_type == DB_TYPE_TIMESCALE:
        components = 'A.......S.'

    file_path = "ChangeLog.d/feature/{}".format(jira)
    os.makedirs(os.path.dirname(file_path), exist_ok=True)

    changelog = "{} ({})\n".format(commit_msg, author)

    with open(file_path, "w") as f:
        f.write(changelog)

    os.system("git add {}".format(file_path))

def version_replace():
    file_path = "include/zbx_dbversion_constants.h"

    with open(file_path, "r") as f:
        content = f.read()

    if db_type == DB_TYPE_MYSQL:
        content = replace_define_int(content, 'ZBX_MYSQL_MAX_VERSION', new_db_max_version_int)
        content = replace_define_str(content, 'ZBX_MYSQL_MAX_VERSION_STR', new_db_max_version_str_in_h_file)
    elif db_type == DB_TYPE_TIMESCALE:
        content = replace_define_int(content, 'ZBX_TIMESCALE_MAX_VERSION', new_db_max_version_int)
        content = replace_define_str(content, 'ZBX_TIMESCALE_MAX_VERSION_STR', new_db_max_version_str_in_h_file)

    with open(file_path, "w") as f:
        f.write(content)

    os.system("git add {}".format(file_path))

### program start

os.system("git reset --hard")
os.system("git clean -dfx")
os.system("git fetch")
os.system("git status")

for rel_branch, feat_sfx in git_branch_sfx:
    feat_branch = "feature/{}-{}".format(jira, feat_sfx)

    os.system("git checkout {}".format(rel_branch))
    os.system("git pull")
    os.system("git checkout -b {}".format(feat_branch))

    commit_msg = commit_msg_build()

    changelog_create(commit_msg)
    version_replace()

    os.system('git commit -m "{}"'.format(commit_msg))
    os.system('git push --set-upstream origin {}'.format(feat_branch))
