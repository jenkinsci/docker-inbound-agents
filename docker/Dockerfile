FROM jenkins/inbound-agent:alpine

USER root

## bash need to be installed for this instruction to work as expected
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Alpine seems to come with libcurl baked in, which is prone to mismatching
# with newer versions of curl. The solution is to upgrade libcurl.
## Ignore apk package pinning as we always want the latest package here
# hadolint ignore=DL3018
RUN apk add --no-cache libcurl curl
# Install Docker client
ARG DOCKER_VERSION=18.03.0-ce
ARG DOCKER_COMPOSE_VERSION=1.21.0
RUN curl --fail --silent --show-error --location \
    "https://download.docker.com/linux/static/stable/$(uname -m)/docker-${DOCKER_VERSION}.tgz" \
  | tar --strip-components=1 -xz -C /usr/local/bin docker/docker

RUN curl --fail --silent --show-error --location \
    "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    > /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

RUN touch /debug-flag
USER jenkins
RUN chmod 750 /home/jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
