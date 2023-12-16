variable "ami_type" {
  description = "value of AMI"
  default = "ami-023c11a32b0207432"
}

variable "instance_type" {
  description = "value of instance type"
  default = "t2.micro"
}

variable "cidr" {
    description = "value of cidr range"
    default = "10.0.0.0/16"
}