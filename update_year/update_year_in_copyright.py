"""
This file performs the following opeation to each file in a repository:
    - Changes year in copyright message

How to use it:
    - !!! Make sure there is no uncommitted work in your repo!
    - Copy this file into repository root, where you need to execute this script.
    - Change configuration below below, set the desired action ACTION = ACTION_PREPARE
    - Execute this script:
        $python update_year_in_copyright.py
    - Review changes carefully.
    - Merge changes manually or using this script ACTION = ACTION_MERGE
"""
########################################################################################################################


ACTION_NONE = 0
ACTION_PREPARE = 1
ACTION_MERGE = 2

ACTION = ACTION_NONE

OLD_YEAR = 2022
NEW_YEAR = 2023
JIRA_ISSUE = "DEV-2476"
COMMIT_MESSAGE_TEMPLATE = ".......... [%s] updated year in copyright message to %d" % (JIRA_ISSUE, NEW_YEAR)

# Configure branches here

# branch, feature_branch_suffix
BRANCHES = [
    # ["master", "6.5"],
    # ["release/6.0", "6.0"],
    # ["release/6.2", "6.2"],
    ["release/6.4", "6.4"],
]
########################################################################################################################
import os

ROOT_DIR = os.path.dirname(os.path.abspath(__file__))


def exec_command(command):
    os.system("cd %s; %s" % (ROOT_DIR, command))

def get_feature_branch_name(feature_branch_suffix):
    return "feature/%s-%s-auto" % (JIRA_ISSUE, feature_branch_suffix)

def get_commit_message(branch):
    return "%s in branch %s" % (COMMIT_MESSAGE_TEMPLATE, branch)

def prepare():
    for branch, feature_branch_suffix in BRANCHES:
        feature_branch = get_feature_branch_name(feature_branch_suffix)
        exec_command("make clean")
        exec_command("git reset --hard")
        exec_command("git clean -dfx")
        exec_command("git status")
        exec_command("git checkout %s" % branch)
        exec_command("git pull")
        exec_command("git checkout -b %s" % feature_branch)


        print ("Updating repository at path: [%s]...\n" % ROOT_DIR)
        replaced_cnt = 0
        for root, dirs, files in os.walk(ROOT_DIR):
            # print("root = [%s]" % root)
            # print("dirs = [%s]" % dirs)
            # print("files = [%s]" % files)

            if ".git" in root:
                continue

            for file in files:
                name, extension = os.path.splitext(file)
                file_path = os.path.join(root, file)

                # print ("Opening [%s]..." % file_path)
                with open(file_path, 'r') as file:
                    file_lines = file.readlines()

                # Replace the target string
                new_file_lines = []
                for line in file_lines:
                    # # Tabs to spaces
                    # line = line.replace('	', '    ')
                    # # Trim trailing spaces
                    # line = line.rstrip(os.linesep).rstrip(" ") + "\n" # take Unix line ending into account
                    line = line.replace('Copyright 2001-%s Zabbix SIA' % OLD_YEAR, 'Copyright 2001-%s Zabbix SIA' % NEW_YEAR)
                    new_file_lines.append(line)

                if file_lines != new_file_lines:
                    # print ("Replacing [%s]..." % file_path)
                    # Write the file out again
                    with open(file_path, 'w') as file:
                        file.writelines(new_file_lines)
                    replaced_cnt += 1

                        # print ("File:")
                        # print (new_filedata)
                        # print ("\n")

        print ("\nReplacement was done in [%d] files." % replaced_cnt)
        exec_command("git add -u")
        exec_command("git commit -m '%s'" % get_commit_message(branch))
        exec_command("git push --set-upstream origin %s" % feature_branch)
        exec_command("git checkout %s" % branch)
        exec_command("git branch -D %s" % feature_branch)

def merge():
    for branch, feature_branch_suffix in BRANCHES:
        feature_branch = get_feature_branch_name(feature_branch_suffix)
        exec_command("make clean")
        exec_command("git reset --hard")
        exec_command("git clean -dfx")
        exec_command("git checkout %s" % feature_branch)
        exec_command("git pull")
        exec_command("git checkout %s" % branch)
        exec_command("git pull")
        exec_command("git merge --squash %s" % feature_branch)
        exec_command("git add -u")
        exec_command("git commit -m '%s'" % get_commit_message(branch))
        exec_command("git push")
        exec_command("git branch -D %s" % feature_branch)
        exec_command("git push -d origin %s" % feature_branch)


if __name__=="__main__":
    if ACTION == ACTION_PREPARE:
        prepare()
    elif ACTION == ACTION_MERGE:
        merge()
    else:
        print ("\nUndefined action. Set variable 'ACTION' in the configuration section of the script.")
