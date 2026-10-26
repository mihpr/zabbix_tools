#!/usr/bin/env bash

# Run this script from the repository dir.

if [ $# -ne 1 ] && { [ $# -ne 2 ] || [ "$2" != "--remote" ]; }; then
    echo "Usage: $(basename "$0") <feature branch suffix> [--remote]"
    echo "  --remote  also delete the branch on origin"
    echo "Example: $(basename "$0") ZBXNEXT-9397-7.0"
    exit 1
fi
TICKET_VERSION=$1

CURRENT_DIR=$(pwd)
WEBROOT=/var/www/html

git worktree remove "${CURRENT_DIR}/../${TICKET_VERSION}"

# remove local branch, the remote one only when --remote is passed
git branch -D feature/${TICKET_VERSION}
if [ "$2" = "--remote" ]; then
    git push origin --delete feature/${TICKET_VERSION}
fi

rm "${WEBROOT}/${TICKET_VERSION}"
