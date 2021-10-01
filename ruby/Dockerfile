# Use debian base
FROM jenkins/inbound-agent:jdk11 as jnlp

FROM ruby:2-stretch

## Ignore apt package pinning as we always want the latest package here
# hadolint ignore=DL3008
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -qy \
        bash \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install JDK from the official agent image
ENV JAVA_HOME=/opt/jdk-11
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jnlp /opt/java/openjdk "${JAVA_HOME}"

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

ARG user=jenkins
RUN useradd -c "Jenkins user" -m ${user} \
    && chmod 750 /home/${user}
USER ${user}
