import os
import re

# (release branch, feature branch suffix)
git_branch_sfx = (

	("release/6.0", "6.0"),
	("release/7.0", "7.0"),
	("release/7.4", "7.4"),
	("master",      "7.5")
)

jira= "ZBXNEXT-10448"
db_type="MySQL"
new_db_max_version_str="9.6"
new_db_max_version_int="90699"
author="mprihodko"

os.system("git reset --hard")
os.system("git clean -dfx")
os.system("git fetch")
os.system("git status")

for rel_branch, feat_sfx in git_branch_sfx:
    feat_branch = "feature/{}-{}".format(jira, feat_sfx)

    os.system("git checkout {}".format(rel_branch))
    os.system("git checkout -b {}".format(feat_branch))

    file_path = "ChangeLog.d/feature/{}".format(jira)
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    commit_msg = "A......PS. [{}] updated maximum supported {} version to {}".format(jira, db_type, new_db_max_version_str)
    changelog = "{} ({})\n".format(commit_msg, author)

    with open(file_path, "w") as f:
        f.write(changelog)

    os.system("git add {}".format(file_path))

    file_path = "include/zbx_dbversion_constants.h"

    with open(file_path, "r") as f:
        content = f.read()

    content = re.sub(
        r"(#define ZBX_MYSQL_MAX_VERSION\s+)\d+",
        rf"\g<1>{new_db_max_version_int}",
        content
    )

    content = re.sub(
        r'(#define ZBX_MYSQL_MAX_VERSION_STR\s+)"[^"]+"',
        rf'\g<1>"{new_db_max_version_str}"',
        content
    )

    with open(file_path, "w") as f:
        f.write(content)

    os.system("git add {}".format(file_path))

    os.system('git commit -m "{}"'.format(commit_msg))
    os.system('git push --set-upstream origin {}'.format(feat_branch))
