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

            steps {
                script {
                   echo 'deploying docker image...'
                    withKubeConfig([credentialsId: 'lke-credentials', serverUrl: 'https://b782cfdd-d88a-460f-938c-d9b989e3960f.eu-central-3-gw.linodelke.net']){
                        sh 'kubectl create deployment nginx-deployment --image=nginx'
                     }
                }
            }
        }
    }
}
