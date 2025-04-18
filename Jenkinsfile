#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('build') {
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }
        stage('test') {
            steps {
                script {
                    echo "Testing the application..."
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    def dockerCmd = 'docker run -p 3080:80 -d austinmwangi/demoa-app:1.1'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@51.21.163.72 ${dockerCmd}"
                    }
                }
            }
        }
    }
}

// def gv 
// pipeline {
//     agent any 
//     tools {
//         maven 'my-maven'
//     }
//     stages {
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
//                        gv.buildJar()
            
//                     }
//                 }
//             }
//             stage("build image") {
//                 steps {
//                     script {
//                       gv.buildImage()
//                         }
//                     }
//                 }
    
//             stage("deploy") {
//                 steps {
//                     script {
//                         gv.deployApp()
//                     }
//                 }
//             }
//         }
    
// }

