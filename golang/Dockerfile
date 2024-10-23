# VERSION_ID=3.20.3

# Use the Jenkins inbound agent with Alpine Linux and JDK 11 as the base image for the first stage
FROM jenkins/inbound-agent:latest-alpine-jdk11 AS jnlp

# Use the Go programming language image with Alpine Linux as the base image for the second stage
FROM golang:1.23.2-alpine3.20

# Update the package list and install OpenJDK 11 JRE
RUN apk -U add openjdk11-jre

# Copy the Jenkins agent binary from the first stage to the second stage
COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
# Copy the Jenkins agent JAR file from the first stage to the second stage
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

# Set the entrypoint to the Jenkins agent binary
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
