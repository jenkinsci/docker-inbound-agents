FROM jenkins/jnlp-slave:alpine

# Switch from the Jenkins user to the root user. This is being done
# intentionally to allow the use of apk and other utilities. It is an
# administrator's responsibility to ensure that user namespacing is enabled in
# their docker daemon, or that this will be handled appropriately
USER root
