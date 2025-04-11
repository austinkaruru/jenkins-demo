def buildApp(){
    echo 'building this app'
}

def testApp(){
    echo 'testing this application'
}

def deployApp(){
    echo 'deploying this application'
    echo "deploying version ${params.VERSION}"
}

return this