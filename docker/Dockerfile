FROM jenkins/inbound-agent:alpine

USER root

# Alpine seems to come with libcurl baked in, which is prone to mismatching
# with newer versions of curl. The solution is to upgrade libcurl.
RUN apk add --no-cache -u libcurl curl

# Install Docker client
ARG DOCKER_VERSION=27.2.0
ARG DOCKER_COMPOSE_VERSION=2.29.7
ARG DOCKER_BUILDX_VERSION=0.16.2
RUN curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-$DOCKER_VERSION.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker

# Install Docker Compose
RUN curl -fsSL https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s | tr '[:upper:]' '[:lower:]'`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Enable buildx plugin
## buildx is released as amd64, and uname calls it x86_64
RUN uname -m > /tmp/arch \
    && sed -i 's/x86_64/amd64/g' /tmp/arch \
    && mkdir -p /usr/libexec/docker/cli-plugins/  \
    && curl -fsSL https://github.com/docker/buildx/releases/download/v$DOCKER_BUILDX_VERSION/buildx-v$DOCKER_BUILDX_VERSION.linux-`cat /tmp/arch` > /usr/libexec/docker/cli-plugins/docker-buildx  \
    && chmod +x /usr/libexec/docker/cli-plugins/docker-buildx \
    && docker buildx install \
    && rm /tmp/arch

RUN touch /debug-flag
USER jenkins
