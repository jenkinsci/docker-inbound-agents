FROM jenkins/inbound-agent:alpine as jnlp

FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine

RUN apk -U add openjdk11-jre git openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
