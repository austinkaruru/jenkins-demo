
pipeline {
    agent none
    stages {
          stage('test') {
            steps {
                script {
                    echo "Testing the application..."
                    echo "Executing pipeline for branch $BRANCH_NAME"
                }
            }
        }
        stage('build') {
            when {
                expression{
                    BRANCH_NAME == 'main'
                }
            }
            steps {
                script {
                    echo "Building the application tuu..."
                }
            }
        }
      stage('deploy') {
            steps {
                script {
                    echo "Deploying the application..."
                }
            }
        }
    }
}