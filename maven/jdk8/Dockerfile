# Use Debian base
FROM jenkins/inbound-agent:jdk8 as jnlp

FROM maven:3.8.6-eclipse-temurin-8

## Ignore apt package pinning as we always want the latest package here
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        git \
        libfontconfig1 \
        libfreetype6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

ARG user=jenkins
RUN useradd -c "Jenkins user" -m ${user} \
    && chmod 750 /home/${user}
USER ${user}
