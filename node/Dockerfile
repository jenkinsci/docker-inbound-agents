FROM jenkins/inbound-agent:alpine as jnlp

FROM node:alpine

RUN apk -U add openjdk8-jre git

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
