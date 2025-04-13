#!/usr/bin/env groovy
@Library('jenkins-shared-library')
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