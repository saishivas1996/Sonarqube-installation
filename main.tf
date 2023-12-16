resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "terraform-ss"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
}

resource "aws_subnet" "subnet1" {
    vpc_id      = aws_vpc.myvpc.id
    cidr_block  = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id   
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt.id
}
  

resource "aws_security_group" "websg" {
    name = "app"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description = "http port"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "sonarqube"
        from_port = 9000
        to_port = 9000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "soanrqube"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        name = "sonarqube"
    }  
}

resource "aws_instance" "sonarqube" {
    ami = var.ami_type
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.websg.id]
    subnet_id = aws_subnet.subnet1.id
    user_data = base64encode(file("userdata.sh"))    
}


output "public-ip-address" {
  value = aws_instance.sonarqube.public_ip
}

