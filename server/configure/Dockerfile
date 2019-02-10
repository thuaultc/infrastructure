FROM alpine

ARG UID
ARG GID

RUN apk add --update bash openssh-client

WORKDIR /app
COPY . /app

RUN addgroup -g ${GID} user && \
    adduser -D -u ${UID} -G user user

USER user

ENTRYPOINT ["/bin/bash", "configure.sh"]
