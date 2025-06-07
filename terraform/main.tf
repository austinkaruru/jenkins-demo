terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "karuru-myapp-bucket"
    key = "myapp/state.tfstate"
    region = "eu-north-1"
  }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.region

}

# --- VPC (Virtual Private Cloud) Configuration ---
# This section defines your isolated network in AWS.
resource "aws_vpc" "myapp-vpc" {
# The CIDR block for the entire VPC, defining its IP address range.
  cidr_block = var.vpc_cidr_block
  tags = {
    # Naming the VPC based on the environment prefix for easy identification.
    Name = "${var.env_prefix}-vpc"
  }
}

# --- Subnet Configuration ---
# This section defines a subnet within your VPC, a logical segmentation of the network.
resource "aws_subnet" "myapp-subnet-1" {
  # Associates this subnet with the VPC defined above.
  vpc_id = aws_vpc.myapp-vpc.id
  # The CIDR block for this specific subnet.
  cidr_block = var.subnet_cidr_block
  # Specifies the Availability Zone where this subnet will be deployed.
  availability_zone = var.avail_zone
  tags = {
    # Naming the subnet.
    Name = "${var.env_prefix}-subnet-1"
  }
}

# --- Internet Gateway Configuration ---
# This section creates an Internet Gateway, which allows communication between your VPC
# and the internet.
resource "aws_internet_gateway" "myapp-igw" {
  # Associates the internet gateway with your VPC.
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    # Naming the internet gateway.
    Name = "${var.env_prefix}-igw"
  }
}

# --- Default Route Table Configuration ---
# This section modifies the default route table associated with your VPC.
# By default, a VPC comes with a main route table.
resource "aws_default_route_table" "default-rtb" {
  # Refers to the ID of the default route table for the VPC.
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  route {
    # Adds a route to the default route table, directing all outbound traffic
    # to the internet gateway. This makes resources in subnets associated with
    # this route table publicly accessible.
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    # Naming the default main route table.
    Name = "${var.env_prefix}-main-rtb"
  }
}

# --- Default Security Group Configuration ---
# This section configures the default security group for your VPC.
# Security groups act as virtual firewalls to control inbound and outbound traffic
# for your instances.
resource "aws_default_security_group" "default-sg" {
  # Associates the security group with your VPC.
  vpc_id = aws_vpc.myapp-vpc.id

  # Inbound rule: Allows SSH access (port 22) from your specified IP address.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  # Inbound rule: Allows HTTP access (port 8080) from anywhere (0.0.0.0/0).
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  # Outbound rule: Allows all outbound traffic from instances associated with this security group.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = [var.anywhere]
    prefix_list_ids = []
  }

  tags = {
    # Naming the default security group.
    Name = "${var.env_prefix}-default-sg"
  }
}

# --- Data Source: Latest Amazon Linux AMI ---
# This section retrieves information about the latest Amazon Linux 2 AMI.
# Data sources allow you to fetch information from AWS.
data "aws_ami" "latest-amazon-linux-image" {
  # Ensures the most recent AMI is selected.
  most_recent = true
  # Specifies that the AMI must be owned by Amazon.
  owners = ["amazon"]
  filter {
    name   = "name"
    # Filters for AMIs with names matching this pattern (Amazon Linux 2).
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    # Filters for AMIs using hardware virtual machine (HVM).
    values = ["hvm"]
  }
}

# --- EC2 Instance Configuration ---
# This section defines your Amazon EC2 instance (virtual server).
resource "aws_instance" "myapp-server" {
  # The Amazon Machine Image (AMI) to use for the instance.
  ami = data.aws_ami.latest-amazon-linux-image.id
  # The type of instance to launch (e.g., t2.micro).
  instance_type = var.instance_type
  # The subnet where the instance will be launched.
  subnet_id = aws_subnet.myapp-subnet-1.id
  # Associates the default security group with this instance.
  vpc_security_group_ids = [aws_default_security_group.default-sg.id]
  # The Availability Zone where the instance will be launched.
  availability_zone = var.avail_zone

  # Assigns a public IP address to the instance, making it accessible from the internet.
  associate_public_ip_address = true
  # The name of the SSH key pair to use for connecting to the instance.
  key_name = "myapp-key-pair"

  user_data = file("entry-script.sh")
  tags = {
    # Naming the EC2 instance.
    Name = "${var.env_prefix}-server"
  }
}


output "ec2_public_ip" {
  # The public IP address assigned to your EC2 instance.
  value       = aws_instance.myapp-server.public_ip
  description = "The public IP address of the EC2 instance"
}