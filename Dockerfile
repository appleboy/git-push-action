FROM ghcr.io/appleboy/drone-git-push:latest

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
