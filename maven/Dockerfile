FROM jenkins/jnlp-slave:alpine as jnlp

FROM maven:3.6.2-jdk-8-slim

RUN apt-get update && \
    apt-get install -y \
        git \
        libfontconfig1 \
        libfreetype6

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/slave.jar /usr/share/jenkins/slave.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
