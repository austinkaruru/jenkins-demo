pipeline {
    agent any 
    tools {
        maven 'my-maven'
    }
    stages {
            stage("build jar") {
                steps {
                    script {
                        echo "Building the application"
                        sh 'mvn package'
                    }
                }
            }
            stage("build image") {
                steps {
                    script {
                        echo "Building the docker image"
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'docker build -t austinmwangi/docker-jenkins:2:0 .'
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh 'docker push austinmwangi/docker-jenkins:2:0'
                        }
                    }
                }
            }
            stage("deploy") {
                steps {
                    script {
                        echo "Deploying the application"
                    }
                }
            }
        }
    
}