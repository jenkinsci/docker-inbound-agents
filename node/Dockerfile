FROM jenkins/jnlp-slave:alpine as jnlp

FROM node:alpine

USER root
RUN apk -U add openjdk8-jre
USER jenkins

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/slave.jar /usr/share/jenkins/slave.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
