#!/usr/bin/env bash

# Run this script from the repository dir.

# Basic usage example:
# - Navigate to the main repository dir
# - Checkout and pull the release branch
# - Run the script like so:
# worktree_add.sh release/7.0 ZBXNEXT-9397-7.0

if [ $# -ne 2 ]; then
    echo "Usage: $(basename "$0") <remote branch to start from> <feature branch suffix>"
    echo "Example: $(basename "$0") release/7.0 ZBXNEXT-9397-7.0"
    exit 1
fi

BASE_BRANCH=$1
TICKET_VERSION=$2

CURRENT_DIR=$(pwd)
WEBROOT=/var/www/html

git fetch origin
git worktree add -b feature/${TICKET_VERSION} "${CURRENT_DIR}/../${TICKET_VERSION}" origin/${BASE_BRANCH}

git push -u origin feature/${TICKET_VERSION}

ln -s "${CURRENT_DIR}/../${TICKET_VERSION}" "${WEBROOT}/${TICKET_VERSION}"
ls -l "${WEBROOT}/${TICKET_VERSION}"
