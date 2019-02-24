FROM python:3.6-alpine

ARG UID
ARG GID

ENV PYTHONUNBUFFERED 1
ENV RKE_CLUSTER_BASE_CONFIG_PATH /app/cluster-base.yml
ENV RKE_OUTPUT_CONFIG_PATH /output

RUN addgroup -g ${GID} user && \
    adduser -D -u ${UID} -G user user && \
    pip install pipenv

WORKDIR /app
COPY --chown=user:user . /app

USER user

RUN pipenv install --deploy

ENTRYPOINT ["pipenv", "run", "python", "cluster.py"]