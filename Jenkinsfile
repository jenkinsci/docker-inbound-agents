pipeline {
    agent none

    options {
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder(logRotator(daysToKeepStr: '10'))
        timestamps()
    }

    triggers {
        cron('@daily')
    }

    stages {
        stage('Build and Test') {
            when {
                expression { !infra.isTrusted() }
            }

            parallel {
                stage('Windows') {
                    agent {
                        label "docker-windows"
                    }
                    steps {
                        bat "powershell -File ./make.ps1 -Target build"
                    }
                }
                stage('Linux') {
                    agent {
                        label "docker&&linux"
                    }
                    steps {
                        sh "make lint"
                        sh "make build"
                        sh "make test"
                    }
                }
            }
        }


        stage('Build and Publish') {
            when {
                expression { infra.isTrusted() }
            }

            parallel {
                stage('Windows') {
                    agent {
                        label "docker-windows"
                    }
                    steps {
                        script {
                            // This function is defined in the jenkins-infra/pipeline-library
                            infra.withDockerCredentials {
                                bat "powershell -File ./make.ps1 -Target push"
                            }
                        }
                    }
                }
                stage('Linux') {
                    agent {
                        label "docker&&linux"
                    }
                    steps {
                        script {
                            // This function is defined in the jenkins-infra/pipeline-library
                            infra.withDockerCredentials {
                                sh 'make push'
                            }
                        }
                    }
                }
            }
        }
    }
}

// vim: ft=groovy
