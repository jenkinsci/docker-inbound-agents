# Use the Jenkins inbound agent with Alpine Linux and JDK 11 as the base image for the first stage
FROM jenkins/inbound-agent:latest-alpine-jdk11 AS jnlp

# Use the .NET Core runtime 2.2 with Alpine Linux as the base image for the second stage
FROM mcr.microsoft.com/dotnet/core/runtime:2.2-alpine

# Copy the Jenkins agent binary from the first stage to the second stage
COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
# Copy the Jenkins agent JAR file from the first stage to the second stage
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

# Set the JAVA_HOME environment variable to the OpenJDK installation path
ENV JAVA_HOME=/opt/java/openjdk
# Copy the Java runtime from the first stage to the specified JAVA_HOME directory
COPY --from=jnlp "$JAVA_HOME" "$JAVA_HOME"
# Add the Java binary directory to the PATH environment variable
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Set the entrypoint to the Jenkins agent binary
ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
