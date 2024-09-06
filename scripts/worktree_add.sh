#!/usr/bin/env bash

# Run this script from the repository dir.

WORKTREE_DIR=$1
BRANCH=$2

CURRENT_DIR=$(pwd)
WEBROOT=/var/www/html

git worktree add --track -b ${BRANCH} "${CURRENT_DIR}/../${WORKTREE_DIR}" remotes/origin/${BRANCH}

ln -s "${CURRENT_DIR}/../${WORKTREE_DIR}" "${WEBROOT}/${WORKTREE_DIR}"
ls -l "${WEBROOT}/${WORKTREE_DIR}"
