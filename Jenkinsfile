pipeline {
    agent any
    environment {
        NEW_VERSION = '1.3.0'
        SERVER_CREDENTIALS = credentials('')
    }
    tools {
        maven 'my-maven'
    }
    parameters{
        string(name: 'VERSION', defaultValue: '', description: 'version to deploy on prod')
        choice(name: 'VERSION', choices: ['1.1.0', '1.2.0', '1.3.0'], description: '')
        booleanParam(name: 'executeTests', defaultValue: true, description: '')
    }
    stages{
        stage("build") {
            steps {
                echo 'building the application...'
                echo "building version ${NEW_VERSION}"
                sh "mvn install"
            }
        }
        stage("test"){
            when {
                expression {
                    parameters.executeTests == true
                }
            }
            steps {
                echo 'testing the application...'
            }

        }
        stage("deploy"){
            steps {
                echo 'deploying the application...'
                withCredentials([
                    usernamePassword(credentials:'server-credentials', usernameVariable: User, passwordVariable: PWD)
                ])
                sh "some script ${USER} ${PWD}"
                echo "deploying version ${VERSION}"
            }
        }
    }
}