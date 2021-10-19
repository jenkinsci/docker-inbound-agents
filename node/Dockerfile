# Use Debian base
FROM jenkins/inbound-agent:jdk11 as jnlp

## Ignore apt package pinning as we always want the latest package here
USER root
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        git \
        libfontconfig1 \
        libfreetype6 \
        nodejs \
        npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
USER jenkins
