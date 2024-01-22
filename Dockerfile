# Use imutable image tags rather than mutable tags (like ubuntu:22.04)
FROM ubuntu:jammy-20240111
# Some tools like yamllint need this
# Pip needs this as well at the moment to install ansible
# (and potentially other packages)
# See: https://github.com/pypa/pip/issues/10219
ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1
WORKDIR /app

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
    && pip install --no-compile --no-cache-dir \
       ansible==7.6.0 \
       ansible-core==2.14.6 \
       cryptography==41.0.1 \
       jinja2==3.1.2 \
       netaddr==0.8.0 \
       jmespath==1.0.1 \
       MarkupSafe==2.1.3 \
       ruamel.yaml==0.17.21 \
       passlib==1.7.4 \
    && rm -rf /var/lib/apt/lists/* /var/log/* \
    && find /usr -type d -name '*__pycache__' -prune -exec rm -rf {} \;