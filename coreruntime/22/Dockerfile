FROM jenkins/inbound-agent:alpine as jnlp

FROM mcr.microsoft.com/dotnet/core/runtime:2.2-alpine

RUN apk --no-cache add bash git openjdk8-jre

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

ARG user=jenkins
RUN adduser -D ${user} \
    && chmod 750 /home/${user}
USER ${user}
