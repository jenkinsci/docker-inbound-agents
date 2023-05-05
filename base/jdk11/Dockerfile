# Use https://github.com/jenkinsci/docker-inbound-agent as base for now
FROM jenkins/inbound-agent:windowsservercore-1809 AS inbound-windows-server-core

ENTRYPOINT ["pwsh.exe", "-f", "C:/ProgramData/Jenkins/jenkins-agent.ps1"]
