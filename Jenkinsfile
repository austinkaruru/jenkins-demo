library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
[$class: 'GitSCMSource',
remote: 'https://github.com/austinkaruru/jenkins-shared-library.git',
credentialsId: 'github-credentials']
)
//@Library('jenkins-shared-library')
def gv
pipeline {
    agent any
    tools {
        maven 'my-maven'
    }
    environment {
        IMAGE_NAME = 'austinmwangi/docker-jenkins:4.0'
    }
    stages {
        stage('build app') {
            steps {
                script {
                    echo 'building application jar.....'
                    buildJar()
                }
            }
        }
      
        stage("build image") {
            steps {
                script {
                    echo 'building docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def dockerComposeCmd = docker-compose -f docker-compose.yaml up --detach"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yaml ubuntu@51.21.163.72:/home/ubuntu"
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@51.21.163.72 ${dockerComposeCmd}"
                    }
                }
            }
        }
    }
}