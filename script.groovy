def buildJar() {
    echo "building this app"
    sh 'mvn package'
}

def buildImage() {
     echo "Building the docker image"
        withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
     sh 'docker build -t austinmwangi/docker-jenkins:2.0 .'
                        sh "echo $PASS | docker login -u $USER --password-stdin"
                        sh 'docker push austinmwangi/docker-jenkins:2.0'
}}


def testApp(){
    echo 'testing this application'
}

def deployApp(){
    echo 'deploying this application'
}
