FROM jenkins/inbound-agent:alpine as jnlp

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine

RUN apk -U add openjdk8-jre git openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]

ARG user=jenkins
RUN adduser -D ${user} \
    && chmod 750 /home/${user}
USER ${user}
