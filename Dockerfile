FROM ghcr.io/appleboy/drone-git-push:1.2.1

COPY entrypoint.sh /entrypoint.sh

RUN git config --system --add safe.directory '*'

USER nobody

ENV GITHUB_WORKSPACE=/github/workspace

WORKDIR ${GITHUB_WORKSPACE}

ENTRYPOINT ["/entrypoint.sh"]
