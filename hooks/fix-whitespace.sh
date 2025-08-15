#!/bin/bash

# This script is intended to be used as git hook to ensure there are
# no trailing whitespaces in commited changes. The script needs to be
# executable and it will be invoked when a 'git commit' command is
# issued.
#
# [1] https://stackoverflow.com/questions/9812054/how-can-i-remove-trailing-whitespace-only-on-changed-lines-in-a-pre-commit-git-h
#

set -e
exec 1>&2

if ! git diff --staged --check > /dev/null; then
        stage_diff=$(mktemp)

        git diff --staged --no-color > "${stage_diff}"

        git apply --allow-empty --index -R "${stage_diff}" || true

        git apply --allow-empty --index --whitespace=fix "${stage_diff}" || true

        rm -f "${stage_diff}"

        if ! git diff --staged --check; then
                echo ""
                echo "^^^^^^^^^^^^^^^^^"
                echo ""
                echo "Failed to auto-fix trailing whitespaces!"
                exit 123
        fi
fi
exit 0
