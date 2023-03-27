FROM jenkins/inbound-agent:jdk11 as jenkins-agent

FROM ruby:3.2.1-bullseye

USER root

# Create default user (must be the same as the official jenkins-agent image)
ARG JENKINS_USERNAME=jenkins
ENV USER=${JENKINS_USERNAME}
ENV HOME=/home/"${JENKINS_USERNAME}"
RUN useradd -m -u 1000 "${JENKINS_USERNAME}"

RUN apt-get update -qq && \
    apt-get install -qy git zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=jenkins-agent /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jenkins-agent /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=jenkins-agent $JAVA_HOME $JAVA_HOME

USER $JENKINS_USERNAME

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
