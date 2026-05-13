import os
import re
import sys

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
    new_db_max_version_str1 = "9.7"
    new_db_max_version_str2 = "9.7.x"
    new_db_max_version_int  = "90799"
elif db_type == DB_TYPE_TIMESCALE:
    new_db_max_version_str1 = "2.27"
    new_db_max_version_str2 = new_db_max_version_str1
    new_db_max_version_int  = "22799"
else:
    print(f"Error: unsupported db_type '{db_type}'")
    sys.exit(1)


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

    file_path = "ChangeLog.d/feature/{}".format(jira)
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    if db_type == DB_TYPE_MYSQL:
        components = 'A......PS.'
    elif db_type == DB_TYPE_TIMESCALE:
        components = 'A.......S.'
    commit_msg = "{} [{}] updated maximum supported {} version to {}".format(components, jira, db_type, new_db_max_version_str1)
    changelog = "{} ({})\n".format(commit_msg, author)

    with open(file_path, "w") as f:
        f.write(changelog)

    os.system("git add {}".format(file_path))

    file_path = "include/zbx_dbversion_constants.h"

    with open(file_path, "r") as f:
        content = f.read()

    if db_type == DB_TYPE_MYSQL:
        content = re.sub(
            r"(#define ZBX_MYSQL_MAX_VERSION\s+)\d+",
            rf"\g<1>{new_db_max_version_int}",
            content
        )

        content = re.sub(
            r'(#define ZBX_MYSQL_MAX_VERSION_STR\s+)"[^"]+"',
            rf'\g<1>"{new_db_max_version_str2}"',
            content
        )
    elif db_type == DB_TYPE_TIMESCALE:
        content = re.sub(
            r"(#define ZBX_TIMESCALE_MAX_VERSION\s+)\d+",
            rf"\g<1>{new_db_max_version_int}",
            content
        )

        content = re.sub(
            r'(#define ZBX_TIMESCALE_MAX_VERSION_STR\s+)"[^"]+"',
            rf'\g<1>"{new_db_max_version_str2}"',
            content
        )

    with open(file_path, "w") as f:
        f.write(content)

    os.system("git add {}".format(file_path))

    os.system('git commit -m "{}"'.format(commit_msg))
    os.system('git push --set-upstream origin {}'.format(feat_branch))
