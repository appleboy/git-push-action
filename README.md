# git-push-action

[![Trivy Security Scan](https://github.com/appleboy/git-push-action/actions/workflows/trivy.yml/badge.svg)](https://github.com/appleboy/git-push-action/actions/workflows/trivy.yml)
[![Lint and Testing](https://github.com/appleboy/git-push-action/actions/workflows/testing.yml/badge.svg?branch=main)](https://github.com/appleboy/git-push-action/actions/workflows/testing.yml)

A GitHub Action to push changes to a remote git repository.

Built with [Golang](https://go.dev) and [drone-git-push](https://github.com/appleboy/drone-git-push).

## Table of Contents

- [git-push-action](#git-push-action)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
    - [Basic Example](#basic-example)
    - [Push with Netrc Authentication](#push-with-netrc-authentication)
    - [Push with Tags](#push-with-tags)
    - [Force Push](#force-push)
  - [Inputs](#inputs)
  - [Authentication](#authentication)
    - [SSH Key](#ssh-key)
    - [Netrc (HTTPS)](#netrc-https)
  - [License](#license)

## Features

- Push commits to remote repositories
- Support for SSH key and netrc authentication
- Create commits with custom author information
- Create and push tags
- Force push and rebase support
- Skip SSL verification for self-hosted git servers

## Usage

### Basic Example

Push changes to a remote repository using SSH key authentication:

```yaml
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Make changes
        run: |
          echo "Updated at $(date)" > VERSION.txt

      - name: Push changes
        uses: appleboy/git-push-action@v1
        with:
          remote: git@github.com:username/repo.git
          ssh_key: ${{ secrets.DEPLOY_KEY }}
          branch: main
          commit: true
          commit_message: "chore: update version file"
```

### Push with Netrc Authentication

For HTTPS authentication using netrc:

```yaml
- name: Push changes
  uses: appleboy/git-push-action@v1
  with:
    remote: https://github.com/username/repo.git
    netrc_machine: github.com
    netrc_username: ${{ github.actor }}
    netrc_password: ${{ secrets.GITHUB_TOKEN }}
    branch: main
    commit: true
    commit_message: "chore: automated update"
```

### Push with Tags

Create and push a tag along with commits:

```yaml
- name: Push changes with tag
  uses: appleboy/git-push-action@v1
  with:
    remote: git@github.com:username/repo.git
    ssh_key: ${{ secrets.DEPLOY_KEY }}
    branch: main
    commit: true
    commit_message: "release: v1.0.0"
    tag: v1.0.0
    followtags: true
```

### Force Push

Force push to overwrite remote branch:

```yaml
- name: Force push changes
  uses: appleboy/git-push-action@v1
  with:
    remote: git@github.com:username/repo.git
    ssh_key: ${{ secrets.DEPLOY_KEY }}
    branch: main
    force: true
```

## Inputs

| Input            | Description                                                | Required | Default                                                 |
| ---------------- | ---------------------------------------------------------- | -------- | ------------------------------------------------------- |
| `remote`         | URL of the remote repository                               | Yes      |                                                         |
| `branch`         | Name of the remote branch to push to                       | No       | `master`                                                |
| `local_branch`   | Name of the local branch to push from                      | No       | `HEAD`                                                  |
| `ssh_key`        | Private SSH key for authentication                         | No       |                                                         |
| `netrc_machine`  | Machine name for netrc authentication                      | No       |                                                         |
| `netrc_username` | Username for netrc authentication                          | No       |                                                         |
| `netrc_password` | Password for netrc authentication                          | No       |                                                         |
| `author_name`    | Git author name for commits                                | No       | `GitHub Actions`                                        |
| `author_email`   | Git author email for commits                               | No       | `41898282+github-actions[bot]@users.noreply.github.com` |
| `commit`         | Commit dirty changes before pushing                        | No       |                                                         |
| `commit_message` | Custom commit message (requires `commit: true`)            | No       |                                                         |
| `tag`            | Create and push a tag with the specified name              | No       |                                                         |
| `followtags`     | Push annotated tags along with commits                     | No       |                                                         |
| `force`          | Enable force push                                          | No       |                                                         |
| `rebase`         | Rebase local branch on top of remote branch before pushing | No       |                                                         |
| `empty_commit`   | Allow creating an empty commit                             | No       |                                                         |
| `no_verify`      | Bypass pre-commit and commit-msg hooks                     | No       |                                                         |
| `skip_verify`    | Skip SSL certificate verification                          | No       |                                                         |
| `remote_name`    | Name of the remote (used in `git remote add`)              | No       | `deploy`                                                |
| `path`           | Path to the git repository                                 | No       |                                                         |

## Authentication

### SSH Key

1. Generate a deploy key:

   ```bash
   ssh-keygen -t ed25519 -C "deploy-key" -f deploy_key -N ""
   ```

2. Add the public key (`deploy_key.pub`) to your target repository's deploy keys with write access.

3. Add the private key (`deploy_key`) as a repository secret (e.g., `DEPLOY_KEY`).

4. Use in your workflow:

   ```yaml
   ssh_key: ${{ secrets.DEPLOY_KEY }}
   ```

### Netrc (HTTPS)

For GitHub repositories, you can use the built-in `GITHUB_TOKEN`:

```yaml
netrc_machine: github.com
netrc_username: ${{ github.actor }}
netrc_password: ${{ secrets.GITHUB_TOKEN }}
```

For other git providers, create a personal access token with appropriate permissions.

## License

MIT
