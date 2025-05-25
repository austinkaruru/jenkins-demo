#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('build app') {
            steps {
               script {
                   echo "building the application..."
               }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                }
            }
        }
        stage('deploy') {
            environment {
               AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
               AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
               AWS_DEFAULT_REGION = 'eu-north-1'  // Set your region
               AWS_CLI_AUTO_PROMPT = 'off'        // Disable interactive prompts
            }
            steps {
                script {
                   echo 'deploying docker image...'

                   sh '''
                       # Install AWS CLI locally if not present
                       if ! command -v aws &> /dev/null; then
                           curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                           unzip awscliv2.zip
                           ./aws/install -i ~/aws-cli -b ~/bin
                           export PATH=~/bin:$PATH
                       fi

                       aws eks update-kubeconfig --region eu-north-1 --name demo-ckuster
                       kubectl create deployment nginx-deployment --image=nginx
                   '''
                }
            }
        }
    }
}