FROM jenkins/jnlp-slave:alpine as jnlp

FROM maven:alpine

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
