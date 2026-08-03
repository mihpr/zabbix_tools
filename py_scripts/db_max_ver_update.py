import os
import re
import sys

###
# Run from the directory with the Zabbix repo.
# Example:
# ~/git/zabbix$ python3 ~/git/zabbix_tools/py_scripts/db_max_ver_update.py

### constants
DB_TYPE_MYSQL     = "MySQL"
DB_TYPE_TIMESCALE = "TimescaleDB"
DB_TYPE_MARIADB   = "MariaDB"

### settings
jira    = "ZBXNEXT-10720"
db_type = DB_TYPE_TIMESCALE
author  = "mprihodko"

# New values to set
# (
#    release branch,
#    feature branch suffix,
#    new_max_ver_commit_msg,
#    new_max_ver_str_h_file,
#    new_max_ver_int_h_file,
# )
if db_type == DB_TYPE_MYSQL:
    pass # TODO: add new implementation
    # new_db_max_version_str_in_commit_msg = "9.7"
    # new_db_max_version_str_in_h_file     = "9.07.x" # this is different for different versions, be careful
    # new_db_max_version_int_in_h_file     = "90799"
elif db_type == DB_TYPE_TIMESCALE:
    versions = (
        ("release/6.0", "6.0", "2.29", "2.29",   "22999"),
        ("release/7.0", "7.0", "2.29", "2.29",   "22999"),
        ("release/7.4", "7.4", "2.29", "2.29",   "22999"),
        ("master",      "7.5", "2.29", "2.29.x", "22999"),
    )
elif db_type == DB_TYPE_MARIADB:
    pass # TODO: add new implementation
    # new_db_max_version_str_in_commit_msg = "12.3"
    # new_db_max_version_str_in_h_file     = "12.03.xx"
    # new_db_max_version_int_in_h_file     = "120399"
else:
    print(f"Error: unsupported db_type '{db_type}'")
    sys.exit(1)

### functions

def commit_msg_build(new_ver):
    if db_type == DB_TYPE_MYSQL:
        components = 'A......PS.'
    elif db_type == DB_TYPE_TIMESCALE:
        components = 'A.......S.'
    elif db_type == DB_TYPE_MARIADB:
        components = 'A......PS.'

    return "{} [{}] updated maximum supported {} version to {}".format(components, jira, db_type, new_ver)

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

def version_replace(max_ver_str, max_ver_int):
    file_path = "include/zbx_dbversion_constants.h"

    with open(file_path, "r") as f:
        content = f.read()

    if db_type == DB_TYPE_MYSQL:
        content = replace_define_str(content, 'ZBX_MYSQL_MAX_VERSION_STR', max_ver_str)
        content = replace_define_int(content, 'ZBX_MYSQL_MAX_VERSION', max_ver_int)
    elif db_type == DB_TYPE_TIMESCALE:
        content = replace_define_str(content, 'ZBX_TIMESCALE_MAX_VERSION_STR', max_ver_str)
        content = replace_define_int(content, 'ZBX_TIMESCALE_MAX_VERSION', max_ver_int)

    elif db_type == DB_TYPE_MARIADB:
        content = replace_define_str(content, 'ZBX_MARIADB_MAX_VERSION_STR', max_ver_str)
        content = replace_define_int(content, 'ZBX_MARIADB_MAX_VERSION', max_ver_int)

    with open(file_path, "w") as f:
        f.write(content)

    os.system("git add {}".format(file_path))

### program start

os.system("git reset --hard")
os.system("git clean -dfx")
os.system("git fetch")
os.system("git status")

for (
    rel_branch,
    feat_sfx,
    new_ver_commit_msg,
    new_ver_str_h_file,
    new_ver_int_h_file,
) in versions:
    os.system("git checkout {}".format(rel_branch))
    os.system("git pull")
    feat_branch = "feature/{}-{}".format(jira, feat_sfx)
    os.system("git checkout -b {}".format(feat_branch))

    commit_msg = commit_msg_build(new_ver_commit_msg)

    changelog_create(commit_msg)
    version_replace(new_ver_str_h_file, new_ver_int_h_file)

    os.system('git commit -m "{}"'.format(commit_msg))
    os.system('git push --set-upstream origin {}'.format(feat_branch))
