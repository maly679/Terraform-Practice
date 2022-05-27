provider "aws" {
  region = "us-east-2"

}

resource "aws_vpc" "vpc-first" {
  cidr_block = "10.0.0.0/16"

  tags = {

    Name = "vpc-first-terraform"
    
  }
}

resource "aws_internet_gateway" "gw-first" {
  vpc_id = aws_vpc.vpc-first.id

  tags = {

    Name = "vpc-second-terraform"

  }

}

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.vpc-first.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-first.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw-first.id
  }

  tags = {
    Name = "prod-route-table-terraform"
  }
}

resource "aws_subnet" "prod-subnet" {
  vpc_id     = aws_vpc.vpc-first.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "vpc-terraform-subnet "
  }
}

resource "aws_route_table_association" "aa1" {
  subnet_id      = aws_subnet.prod-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}



resource "aws_security_group" "allow_web" {
  name        = "allow_terraform_web"
  description = "Allow web traffic in internet gateway."
  vpc_id      = aws_vpc.vpc-first.id

//HTTPS access to the internet gateway i.e the port
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

//HTTP access to the internet gateway i.e the port
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 //SSH access to the internet gateway i.e the port
ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.prod-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw-first]
}

resource "aws_instance" "web-server-instance" {

  ami = "ami-0aeb7c931a5a61206"
  instance_type = "t2.micro"
  availability_zone = "us-east-2a"
  key_name = "terraform-access-key"

  network_interface {
    
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id

  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo First Web Server Created > /var/www/html/index.html'
                EOF

tags = {
  Name = "web-server"
  }

}



//Other practice code.






# resource "aws_subnet" "first-subnet" {
#   vpc_id     = aws_vpc.first-VPC.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "prod-terraform-subnet"
#   }
# }

# resource "aws_vpc" "first-VPC" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "prod-terraform-vpc"
#   }
# }

# resource "aws_subnet" "second-subnet" {
#   vpc_id     = aws_vpc.second-VPC.id
#   cidr_block = "10.1.1.0/24"

#   tags = {
#     Name = "dev-terraform-subnet"
#   }
# }

# resource "aws_vpc" "second-VPC" {
#   cidr_block = "10.1.0.0/16"
#   tags = {
#     Name = "dev-terraform-vpc"
#   }
# }
# # resource "aws_instance" "web" {
# #   ami           = data.aws_ami.ubuntu.id
# #   instance_type = "t3.micro"

# #   tags = {
# #     Name = ""
# #   }
# # }

# # resource "aws_instance" "terraform_created" {
# #   ami = "ami-0c6a6b0e75b2b6ce7"
# #   instance_type = "t2.micro"
# #   tags = {
# #     Name = "first_terraform_server"
# #   }

# # }
# # resource "aws_instance" "terraform_second_created" {
# #   ami = "ami-0c6a6b0e75b2b6ce7"
# #   instance_type = "t2.micro"
# #   tags = {
# #     Name = "second-terraform-server"
# #   }

# # }


# #  resource "<provider>_<resource_type>" "name" {

# #      config options....
# #      key = "value"
# #      key2 = "another value"

# #  }

