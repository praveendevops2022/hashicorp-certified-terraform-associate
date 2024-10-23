resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-0db2b58117f103024" # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-ec2-vm-t2-large-1" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.large"
  availability_zone      = "us-east-1a"
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  root_block_device {
    volume_size = 20  # Set to 20 GB
    volume_type = "gp3"  # General Purpose SSD (you can change to "io1" or "gp3" based on your needs)
  }

  tags = {
    "Name" = "web-t2-large-1-master"
  }
}

resource "aws_instance" "my-ec2-vm-t2-large-2" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.large"
  availability_zone      = "us-east-1a"
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  root_block_device {
    volume_size = 20  # Set to 20 GB
    volume_type = "gp3"  # General Purpose SSD (you can change to "io1" or "gp3" based on your needs)
  }

  tags = {
    "Name" = "web-t2-large-2-worker"
  }
}

output "instance_1_ip" {
  value = aws_instance.my-ec2-vm-t2-large-1.public_ip
}

output "instance_2_ip" {
  value = aws_instance.my-ec2-vm-t2-large-2.public_ip
}