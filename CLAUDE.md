# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitHub Action that pushes changes to a remote git repository. It wraps [drone-git-push](https://github.com/appleboy/drone-git-push), a Go-based tool for git push operations.

## Architecture

This is a **composite action** (not Docker-based) with two main components:

- **action.yml**: GitHub Action definition that runs as a composite action with two shell steps:
  1. Adds the action path to GitHub PATH
  2. Executes entrypoint.sh with all inputs passed as `INPUT_*` environment variables

- **entrypoint.sh**: Shell script that:
  1. Detects platform (Linux/Darwin/Windows) and architecture (amd64/arm64)
  2. Downloads the appropriate drone-git-push binary from GitHub releases (default v1.2.1)
  3. Caches the binary to avoid re-downloading on subsequent runs
  4. Validates the binary with `--version` check
  5. Executes the binary with all passed arguments

**Environment Variables**:

- `BINARY_VERSION`: Controls the drone-git-push version (default: 1.2.1), set via `version` input in action.yml
- `BINARY_RELEASE_URL`: Controls the download source URL (default: GitHub releases)
- `INPUT_*`: All action inputs are passed as `INPUT_*` environment variables (e.g., `ssh_key` → `INPUT_SSH_KEY`)
- The drone-git-push binary internally converts `INPUT_*` variables to `PLUGIN_*` variables for processing

All business logic (git operations, authentication, push) is handled by the upstream drone-git-push binary; this repo is primarily a GitHub Action wrapper.

## Testing

The action is tested via [.github/workflows/testing.yml](.github/workflows/testing.yml) which runs on push to main. It tests the action by:

1. Generating random content with `openssl rand`
2. Using the action to commit and push to test branches (branch01, branch02, branch03)
3. Testing different author configurations (GitHub Actions bot, default user, custom Gitea bot)

To test locally:

```bash
# Set required environment variables
export GITHUB_ACTION_PATH="/path/to/action"
export INPUT_REMOTE="git@github.com:user/repo.git"
export INPUT_BRANCH="test-branch"
export INPUT_SSH_KEY="$(cat ~/.ssh/id_rsa)"
export INPUT_COMMIT="true"
export INPUT_COMMIT_MESSAGE="test commit"

# Run the entrypoint script
./entrypoint.sh
```

## Releases

Releases are automated via GoReleaser ([.goreleaser.yaml](.goreleaser.yaml)). Push a git tag matching `v[0-9]*.[0-9]*.[0-9]*` to trigger a release via [.github/workflows/goreleaser.yml](.github/workflows/goreleaser.yml). Note: GoReleaser skips builds (`skip: true`) and only creates changelog-based GitHub releases.
