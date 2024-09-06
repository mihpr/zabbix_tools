#!/usr/bin/env bash

# Run this script from the repository dir.

WORKTREE_DIR=$1
BRANCH=$2

CURRENT_DIR=$(pwd)
WEBROOT=/var/www/html

git worktree remove "${CURRENT_DIR}/../${WORKTREE_DIR}"
git branch -D ${BRANCH}

rm "${WEBROOT}/${WORKTREE_DIR}"
