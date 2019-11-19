FROM jenkins/jnlp-slave:alpine as jnlp

FROM mcr.microsoft.com/dotnet/core/runtime:3.0-alpine

RUN apk -U add openjdk8-jre

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]