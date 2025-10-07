# syntax=docker/dockerfile:1

# Use imutable image tags rather than mutable tags (like ubuntu:24.04)
FROM ubuntu:24.04

# Some tools like yamllint need this
# Pip needs this as well at the moment to install ansible
# (and potentially other packages)
# See: https://github.com/pypa/pip/issues/10219
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update -q \
    && apt-get install -yq --no-install-recommends \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    sshpass \
    vim \
    rsync \
    iputils-ping \
    telnet \
    openssh-client \
    smbclient \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/*

RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    --mount=type=cache,sharing=locked,id=pipcache,target=/root/.cache/pip \
    python3 -m venv /opt/venv \
    && . /opt/venv/bin/activate \
    && pip install --upgrade pip \
    && pip install --no-compile --no-cache-dir -r requirements.txt \
    && find /opt/venv -type d -name '__pycache__' -prune -exec rm -rf {} \;

ENV PATH="/opt/venv/bin:$PATH"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
CMD ["/bin/bash"]