FROM alpine:latest

ENV VERSION "0.1.16"

RUN apk add curl && \
    curl -L -o /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v${VERSION}/rke_linux-amd64 && \
    chmod +x /usr/local/bin/rke

ARG UID
ARG GID

RUN addgroup -g ${GID} user && \
    adduser -D -u ${UID} -G user user

WORKDIR /config

USER user

RUN ls -la /config && \
    ls -la /home/user

ENTRYPOINT ["rke"]
