#!/usr/bin/env bash

# Review a merge commit with conflicts
https://stackoverflow.com/questions/64199381/how-to-inspect-manual-conflict-resolution-in-merge-commits-where-the-resolution

merge=6fb21bdbacf
git checkout $merge^1
git merge $merge^2
git diff $merge
