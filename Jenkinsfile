pipeline {
    agent { label 'docker' }

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
                        withCredentials([[$class: 'ZipFileBinding',
                           credentialsId: 'jenkins-dockerhub',
                                variable: 'DOCKER_CONFIG']]) {
                            bat "powershell -File ./make.ps1 -Target push"
                        }
                    }
                }
                stage('Linux') {
                    agent {
                        label "docker&&linux"
                    }
                    steps {
                        withCredentials([[$class: 'ZipFileBinding',
                           credentialsId: 'jenkins-dockerhub',
                                variable: 'DOCKER_CONFIG']]) {
                            sh 'make push'
                        }
                    }
                }
            }
        }
    }
}

// vim: ft=groovy
