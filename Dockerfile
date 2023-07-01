FROM ghcr.io/appleboy/drone-git-push:1.0.5

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
