library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
[$class: 'GitSCMSource',
remote: 'https://github.com/austinkaruru/jenkins-shared-library.git',
credentialsId: 'github-credentials']
)
//@Library('jenkins-shared-library')
def gv
pipeline {
    agent any
    tools {
        maven 'my-maven'
    }
   
    stages {
        stage('increment app version') {
                steps{
                    script{
                        echo 'incrementing app version...'
                        sh 'mvn build-helper:parse-version versions:set \
                            -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                            versions:commit'
                        def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                        def version = matcher[0][1]
                        env.IMAGE_NAME = "austinmwangi/docker-jenkins:$version-$BUILD_NUMBER"
                    }
                }
            }
        stage('build app') {
            steps {
                script {
                    echo 'building application jar.....'
                    buildJar()
                }
            }
        }
      
        stage("build image") {
            steps {
                script {
                    echo 'building docker image...'
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'
                    def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    def ubuntuInstance = "ubuntu@51.21.163.72"
                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ${ubuntuInstance}:/home/ubuntu"
                        sh "scp docker-compose.yaml ${ubuntuInstance}:/home/ubuntu"
                        sh "ssh -o StrictHostKeyChecking=no ${ubuntuInstance} ${shellCmd}"
                    }
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