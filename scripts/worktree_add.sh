#!/usr/bin/env bash

# Run this script from the repository dir.

# Basic usage example:
# - Navigate to the main repository dir
# - Checkout and pull the release branch
# - Run the script like so:
# worktree_add.sh ZBXNEXT-9397-7.0

WORKTREE_DIR=$1
BRANCH=$2

if [[ -z "$BRANCH" ]]; then
	BRANCH="feature/${WORKTREE_DIR}"
fi

CURRENT_DIR=$(pwd)
WEBROOT=/var/www/html


git worktree add -b ${BRANCH} "${CURRENT_DIR}/../${WORKTREE_DIR}"
git push -u origin ${BRANCH}

ln -s "${CURRENT_DIR}/../${WORKTREE_DIR}" "${WEBROOT}/${WORKTREE_DIR}"
ls -l "${WEBROOT}/${WORKTREE_DIR}"
