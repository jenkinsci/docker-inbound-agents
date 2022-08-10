ARG JAVA_VERSION="11.0.16_8"
FROM eclipse-temurin:${JAVA_VERSION}-jdk-focal AS jdk11-build
# Generate smaller java runtime without unneeded files
# for now we include the full module path to maintain compatibility
# while still saving space (approx 200mb from the full distribution)
RUN jlink \
    --add-modules ALL-MODULE-PATH \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime

# Use Debian base for both the agent and the resulting image (maven)
FROM jenkins/inbound-agent:jdk17-preview as jnlp

FROM maven:3.8.6-eclipse-temurin-17

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

# Retrieve JDK11 for running jenkins agent process but do not use it as default
COPY --from=jdk11-build /javaruntime /opt/jdk-11

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

ARG user=jenkins
RUN useradd -c "Jenkins user" -m ${user} \
    && chmod 750 /home/${user}
USER ${user}
