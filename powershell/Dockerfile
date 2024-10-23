FROM jenkins/inbound-agent:latest-alpine-jdk11 AS jnlp

FROM mcr.microsoft.com/powershell:7.4-alpine-3.17

RUN apk -U add openjdk11-jre

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
