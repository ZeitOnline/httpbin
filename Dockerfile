FROM python:3.14.7-slim@sha256:caaf356f40667c496d405780745b9ac25771c189a51dfcc42430d531ea09f8a2 AS base
LABEL org.opencontainers.image.name=europe-west3-docker.pkg.dev/zeitonline-engineering/docker-zon/httpbin

COPY --from=ghcr.io/astral-sh/uv:0.12.18@sha256:3adc3706091ce7c2fe595e669628caedd6d951551b92b258b7e7dbe06d9440bc /uv /usr/bin/
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
