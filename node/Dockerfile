FROM jenkins/inbound-agent:alpine as jnlp

FROM node:alpine

## Ignore apk package pinning as we always want the latest package here
# hadolint ignore=DL3018
RUN apk --no-cache add bash git

# Install JDK from the official agent image
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jnlp "${JAVA_HOME}" "${JAVA_HOME}"

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

ARG user=jenkins
RUN adduser -D ${user} \
    && chmod 750 /home/${user}
USER ${user}
