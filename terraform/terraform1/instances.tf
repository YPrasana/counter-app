resource "aws_instance" "nginx1" {

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo amazon-linux-extras enable nginx1
    sudo systemctl start nginx
    EOF

  tags = local.common_tags

}



resource "aws_instance" "nginx2" {

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo amazon-linux-extras enable nginx1
    sudo systemctl start nginx
    EOF

  tags = local.common_tags
}

resource "aws_instance" "nginx3" {

  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet3.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  user_data = <<EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo amazon-linux-extras enable nginx1
    sudo systemctl start nginx
    EOF
  tags      = local.common_tags
}