#!/bin/sh

set -eu

export GITHUB="true"

git config --global --add safe.directory "$GITHUB_WORKSPACE"

sh -c "/bin/drone-git-push $*"
