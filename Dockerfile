FROM ghcr.io/appleboy/drone-git-push:1.2.1

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
