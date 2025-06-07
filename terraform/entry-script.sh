 #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user

    # Wait for docker to be ready
    sleep 10

    # Install docker compose
    sudo yum install docker-compose-plugin