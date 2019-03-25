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
        stage('Build') {
            steps {
                sh 'make build'
            }
        }

        stage('Publish') {
            when {
                expression { infra.isTrusted() }
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

// vim: ft=groovy
