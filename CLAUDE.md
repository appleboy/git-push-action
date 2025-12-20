# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitHub Action that pushes changes to a remote git repository. It wraps [drone-git-push](https://github.com/appleboy/drone-git-push), a Go-based tool for git push operations.

## Architecture

- **Dockerfile**: Uses `ghcr.io/appleboy/drone-git-push:1.1.1` as base image, runs as non-root user (`nobody`)
- **entrypoint.sh**: Shell script that sets `GITHUB=true`, configures git safe directory, and invokes `/bin/drone-git-push`
- **action.yml**: GitHub Action definition with inputs for authentication (SSH key or netrc), branch configuration, commit options, and push settings

The action runs as a Docker container. GitHub Actions automatically converts action inputs to `PLUGIN_*` environment variables (e.g., `ssh_key` becomes `PLUGIN_SSH_KEY`), which drone-git-push reads. All business logic is in the upstream binary; this repo is primarily a GitHub Action wrapper.

## Testing

The action is tested via `.github/workflows/testing.yml` which runs on push to main. It tests the action by:

1. Generating random content
2. Using the action to commit and push to test branches (branch01, branch02, branch03)

To test locally, build and run the Docker container:

```bash
docker build -t git-push-action .
```

## Releases

Releases are automated via GoReleaser (`.goreleaser.yaml`). Push a git tag to trigger a release via `.github/workflows/goreleaser.yml`.
