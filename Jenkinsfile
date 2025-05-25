#!/usr/bin/env groovy

pipeline {
    agent any
    tools {
        maven 'my-maven'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage('build app') {
            steps {
                script {
                    echo "building the application..."
                    sh 'mvn clean package'
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t austinmwangi/docker-jenkins:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh "docker push austinmwangi/docker-jenkins:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('deploy') {
                    environment {
                       AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                       AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                       APP_NAME = 'java-maven-app'
                    }
                    steps {
                        script {
                        def kubeconfig = "${env.WORKSPACE}/kubeconfig"
                           echo 'deploying docker image...'

                           sh "aws eks update-kubeconfig --region eu-north-1 --name demo-cluster --kubeconfig ${kubeconfig}"

                           withEnv(["KUBECONFIG=.kube/config"]) {

                           sh 'echo " --checking for proxy env vars"'
                           sh 'env | grep -i proxy || true'
                           sh 'echo "----------------"'
                           sh 'export IMAGE_NAME && envsubst < kubernetes/deployment.yaml | kubectl apply -f -'
                           sh 'envsubst < kubernetes/service.yaml | kubectl apply -f -'
                            }
                        }
                    }
                }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-pat', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        // git config here for the first time run
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh "git remote set-url origin https://${USER}:${PASS}@gitlab.com/austinkaruru/jenkins-demo.git"
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}
