# git-push-action

[![Lint and Testing](https://github.com/appleboy/git-push-action/actions/workflows/testing.yml/badge.svg?branch=main)](https://github.com/appleboy/git-push-action/actions/workflows/testing.yml)

Git push changes to a remote git repository.

This thing is built using [Golang](https://go.dev) and [drone-git-push](https://github.com/appleboy/drone-git-push). 🚀

## Input variables

See [action.yml](./action.yml) for more detailed information.

| Variable       | Description                                  | Default                                               |
| -------------- | -------------------------------------------- | ----------------------------------------------------- |
| author_name    | git author name                              | GitHub Actions                                        |
| author_email   | git author email                             | 41898282+github-actions[bot]@users.noreply.github.com |
| netrc_machine  | netrc machine                                |                                                       |
| netrc_username | netrc username                               |                                                       |
| netrc_password | netrc password                               |                                                       |
| ssh_key        | private ssh key                              |                                                       |
| remote         | url of the remote repo                       |                                                       |
| remote_name    | name of the remote repo                      | deploy                                                |
| branch         | name of remote branch                        | master                                                |
| local_branch   | name of local branch                         | HEAD                                                  |
| path           | path to git repo                             |                                                       |
| force          | force push to remote                         |                                                       |
| followtags     | push to remote with tags                     |                                                       |
| skip_verify    | skip ssl verification                        |                                                       |
| commit         | commit dirty changes                         |                                                       |
| commit_message | commit message                               |                                                       |
| tag            | tag to add to the commit                     |                                                       |
| empty_commit   | allow empty commit                           |                                                       |
| no_verify      | bypasses the pre-commit and commit-msg hooks |                                                       |
| rebase         | rebase local branch on top of remote branch  |                                                       |

## Usage

```yaml
name: testing

on:
  push:

jobs:
  testing:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: update changes
        run: |
          openssl rand -hex 16 > test.txt

      - name: git push changes
        uses: appleboy/git-push-action@v1.0.0
        with:
          author_email: teabot@gitea.io
          author_name: GiteaBot
          branch: main
          commit: true
          commit_message: "[skip ci] Updated changes by gitea bot"
          remote: git@github.com:appleboy/git-push-action.git
          ssh_key: ${{ secrets.DEPLOY_KEY }}
```
