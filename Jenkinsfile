def gv

pipeline {
    agent any
    
    parameters {
        choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Run tests before deployment')
    }
    
    stages {
        stage('Init') {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        
        stage("Build") {
            steps {
                script {
                    gv.buildApp()
                }
            }
        }
        
        stage("Test") {
            when {
                expression {
                    return params.executeTests
                }
            }
            steps {
                script {
                    gv.testApp()  // Fixed: This should likely be testApp() instead of deployApp()
                }
            }
        }
        
        stage("Deploy") {
            steps {
                script {
                    gv.deployApp()
                    echo "Deploying version ${params.VERSION}"
                }
            }
        }
    }
}
