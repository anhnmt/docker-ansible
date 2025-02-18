# Use imutable image tags rather than mutable tags (like ubuntu:22.04)
FROM ubuntu:22.04
# Some tools like yamllint need this
# Pip needs this as well at the moment to install ansible
# (and potentially other packages)
# See: https://github.com/pypa/pip/issues/10219
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1
WORKDIR /app

COPY requirements.txt ./

RUN apt update -q \
    && apt install -yq --no-install-recommends \
       curl \
       iputils-ping \
       python3 \
       python3-pip \
       sshpass \
       vim \
       rsync \
       openssh-client \
    && pip install --no-compile --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/* /var/log/* \
    && find /usr -type d -name '*__pycache__' -prune -exec rm -rf {} \;