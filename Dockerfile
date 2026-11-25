FROM python:3.15.2-slim@sha256:63bb298d2b7b88f176f51b5189f54ce6535c997682ea70885d2132f5d473a8a5 AS base
LABEL org.opencontainers.image.name=europe-west3-docker.pkg.dev/zeitonline-engineering/docker-zon/httpbin

COPY --from=ghcr.io/astral-sh/uv:0.13.10@sha256:a3ea1357342c1a4bf9a0c53a3deb1b55379aefa037338d8113d5771efa01774f /uv /usr/bin/
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

ENTRYPOINT ["python", "-m", "gunicorn", "-b", "0.0.0.0:8080", "httpbin:app", "-k", "gevent", "--no-control-socket"]

# Security updates run last, to intentionally bust the docker cache.
USER root
RUN apt-get update && apt-get -y upgrade && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER app
