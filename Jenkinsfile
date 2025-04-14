#!/usr/bin/env groovy

//
// pipeline {
//     agent none
//     stages {
//           stage('test') {
//             steps {
//                 script {
//                     echo "Testing the application..."
//                     echo "Executing pipeline for branch $BRANCH_NAME"
//                 }
//             }
//         }
//         stage('build') {
//             when {
//                 expression{
//                     BRANCH_NAME == 'main'
//                 }
//             }
//             steps {
//                 script {
//                     echo "Building the application tuu..."
//                 }
//             }
//         }
//       stage('deploy') {
//             steps {
//                 script {
//                     echo "Deploying the application..."
//                 }
//             }
//         }
//     }
// }

// library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
// [$class: 'GitSCMSource',
// remote: 'https://github.com/austinkaruru/jenkins-shared-library.git',
// credentialsId: 'github-credentials'
// ]
// )
// @Library('jenkins-shared-library')
// def gv

pipeline {
    agent any
    tools {
        maven 'my-maven'
    }
    stages {
//             stage("init"){
//                 steps {
//                     script{
//                         gv = load "script.groovy"
//                     }
//                 }
//             }
//             stage("build jar too") {
//                 steps {
//                     script {
//                         buildJar()
//                     }
//                 }
//             }
//
            stage('increment version') {
                steps{
                    script{
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
            stage('build app'){
                steps{
                    script{
                        echo "building the application..."
                        sh 'mvn clean package'
                    }
                }
            }
            stage('build image') {
                steps {
                    script {
                        echo "building the docker image..."
                         withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                         sh "docker build -t austinmwangi/docker-jenkins:${IMAGE_NAME} ."
                         sh "echo $PASS | docker login -u $USER --password-stdin"
                         sh "docker push austinmwangi/docker-jenkins:${IMAGE_NAME}"
                                    }
                                }
                            }
                        }

//             stage("deploy") {
//                 steps {
//                     script {
//                         gv.deployApp()
//                     }
//                 }
//             }
                stage('deploy'){
                steps {
                    script{
                        echo 'deploying docker image to EC2'
                    }
                }
        }
        stage('commit version update'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'github-pat', passwordVariable: 'PASS', usernameVariable: 'USER')]){

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/austinkaruru/jenkins-demo.git"

                        sh 'git add .'
                        sh 'git commit -m "jenkins ci version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
}
}