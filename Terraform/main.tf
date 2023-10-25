provider "aws" {
    region = "eu-north-1"
    access_key = var.aws_accses_key
    secret_key = var.aws_secret_key
}
resource "aws_instance" "name" {
  count = 1
  ami = var.aws_ami
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name = var.aws_key
  instance_type = var.aws_instance_type
  subnet_id = aws_subnet.public.id
  user_data = file("file.sh")
  tags = {
    Name = "terraform_1"
    Owner = "___ ___ ___ ___"
    Project = "___ ___ ___ ___"
  }
}
resource "aws_security_group" "web" {
    name = "web"
    vpc_id = aws_vpc.main_vpc.id
    description = "Dynamic SG"
    dynamic "ingress" {
        for_each = ["80", "443", "8080", "22"]
        content {
            from_port = ingress.value
            to_port = ingress.value
            cidr_blocks = ["0.0.0.0/0"]
            protocol = "tcp"
        }
    }   
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "terraform_SG"
    }
}
