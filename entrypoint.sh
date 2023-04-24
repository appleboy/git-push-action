#!/bin/sh

set -eu

export GITHUB="true"

# Configure git to trust the workspace despite the different owner
git config --global --add safe.directory "$GITHUB_WORKSPACE"

sh -c "/bin/drone-git-push $*"
