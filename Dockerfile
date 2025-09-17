FROM python:3.13-slim@sha256:58c30f5bfaa718b5803a53393190b9c68bd517c44c6c94c1b6c8c172bcfad040 AS base
LABEL org.opencontainers.image.name=europe-west3-docker.pkg.dev/zeitonline-engineering/docker-zon/httpbin

COPY --from=ghcr.io/astral-sh/uv:0.8.17@sha256:e4644cb5bd56fdc2c5ea3ee0525d9d21eed1603bccd6a21f887a938be7e85be1 /uv /usr/bin/
ENV UV_NO_MANAGED_PYTHON=1 \
    UV_NO_CACHE=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_FROZEN=1 \
    UV_INDEX_PYPI_ZON_USERNAME="oauth2accesstoken"

WORKDIR /app
RUN groupadd --gid=10000 app && \
    useradd --uid=10000 --gid=app --no-user-group \
    --create-home --home-dir /app app && \
    chown -R app:app /app
USER app
RUN uv venv --allow-existing /app
ENV PATH=/app/bin:$PATH \
    UV_PROJECT_ENVIRONMENT=/app

COPY pyproject.toml uv.lock ./
COPY httpbin httpbin
RUN --mount=type=secret,id=GCLOUD_TOKEN,env=UV_INDEX_PYPI_ZON_PASSWORD \
    uv sync --group deploy

ENTRYPOINT ["python", "-m", "gunicorn", "-b", "0.0.0.0:8080", "httpbin:app", "-k", "gevent"]

# Security updates run last, to intentionally bust the docker cache.
USER root
RUN apt-get update && apt-get -y upgrade && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER app
