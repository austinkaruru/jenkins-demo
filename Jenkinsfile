pipeline {
    agent any {
        tools {
            maven 'my-maven'
        }
        stages {
            stage("build jar") {
                steps {
                    script {
                        echo "Building the application"
                        sh 'maven package'
                    }
                }
            }
            stage("build image") {
                steps {
                    script {
                        echo "Building the docker image"
                        withCredentials([usernamePassword(credentialsID: '925f32aa-1277-4113-87d4-1f12be4e1124', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
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
}