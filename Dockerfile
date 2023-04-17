FROM nikolaik/python-nodejs:python3.8-nodejs19-bullseye

ARG SSL_KEYSTORE_PASSWORD
USER root

WORKDIR /workspaces/nba-monte-carlo

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
  gcc \
  g++ \
  git \
  make \
  python3.8-dev \
  # python3.8-venv \
  unzip \
  wget \
  gfortran \
  musl-dev \
  glibc-source \
  && rm -rf /var/lib/apt/lists/* \
  && wget https://github.com/duckdb/duckdb/releases/download/v0.6.0/duckdb_cli-linux-amd64.zip --no-check-certificate && unzip duckdb_cli-linux-amd64.zip \
  && pip install --no-cache-dir meltano singer-sdk

COPY meltano.yml ./

RUN meltano --log-level=debug --environment=docker install extractors
RUN meltano --log-level=debug --environment=docker install loaders
RUN meltano --log-level=debug --environment=docker install mappers
RUN meltano --log-level=debug --environment=docker install utility dbt-duckdb

COPY Makefile .
COPY transform ./transform
COPY analyze ./analyze
COPY data ./data
