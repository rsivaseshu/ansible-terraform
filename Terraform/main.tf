data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "dev_machine" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = "rs-mum-9"

  user_data = "${file("user-data-apache.sh")}" 

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} >> /etc/ansible/hosts"
  }
  tags = {
    Environment = "dev"
    Name = "${var.name}-server"
    os = "ubuntu"
  }
}
