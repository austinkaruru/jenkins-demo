#!/usr/bin/env groovy
library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
[$class: 'GitSCMSource',
remote: 'https://github.com/austinkaruru/jenkins-shared-library/tree/master',
credentialsId: 'github-credentials'
]
)
//@Library('jenkins-shared-library')
def gv

pipeline {
    agent any 
    tools {
        maven 'my-maven'
    }
    stages {
            stage("init"){
                steps {
                    script{
                        gv = load "script.groovy"
                    }
                }
            }
            stage("build jar") {
                steps {
                    script {
                        buildJar()
                    }
                }
            }
            stage("build image") {
                steps {
                    script {
                        buildImage'austinmwangi/docker-jenkins:4.0'
                        dockerLogin()
                        dockerPush 'austinmwangi/docker-jenkins:4.0'
                        }
                    }
                }
    
            stage("deploy") {
                steps {
                    script {
                        gv.deployApp()
                    }
                }
            }
        }
    
}