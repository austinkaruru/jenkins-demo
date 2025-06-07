# Define input variables that will be used throughout the configuration.
# These allow for dynamic values to be passed into the Terraform plan.
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
} # The CIDR block for the VPC, defining its IP address range.
variable "subnet_cidr_block" {
  default = "10.0.10.0/24"
}
variable "avail_zone" {
  default = "eu-north-1a"
}
variable "env_prefix" {
  default = "dev"
}
variable "anywhere" {
  default = "0.0.0.0/0"
} # Used for restricting SSH access to a specific IP.
variable "instance_type" {
  default = "t3.micro"
  description = "The type of EC2 instance to launch (e.g., t3.micro)"
} # Specifies the EC2 instance type (e.g., t2.micro).
variable "region" {
  default = "eu-north-1"
} 