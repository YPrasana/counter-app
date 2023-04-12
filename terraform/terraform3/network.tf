#networking#
#1. default vpc
resource "aws_default_vpc" "default" {
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = local.common_tags
}

#2. Create Internet Gateway that associates with default vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_default_vpc.default.id

  tags = local.common_tags
}

#3. create 3 public subnets 

resource "aws_subnet" "subnet1" {
  cidr_block              = var.vpc_subnets_cidr_block[0]
  vpc_id                  = aws_default_vpc.default.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = local.common_tags
}

resource "aws_subnet" "subnet2" {
  cidr_block              = var.vpc_subnets_cidr_block[1]
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_default_vpc.default.id
  tags = local.common_tags
}

resource "aws_subnet" "subnet3" {
  cidr_block              = var.vpc_subnets_cidr_block[2]
  availability_zone       = data.aws_availability_zones.available.names[2]
  vpc_id                  = aws_default_vpc.default.id
  tags = local.common_tags
  
}

#routing#
#4. create the route table and associate the route table with vpc
resource "aws_route_table" "rtb" {
  vpc_id = aws_default_vpc.default.id
  #default route and pointing that to internet gateway by this rule rule only traffic gets out of our vpc through that internet gate way
  route {
    cidr_block = var.rtb_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.common_tags
}

#5. associate the route table with the subnet1
resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

#6.associate the route table with the subnet2
resource "aws_route_table_association" "rta-subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.rtb.id
}

#associate the route table with the subnet2
resource "aws_route_table_association" "rta-subnet3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

#security groups#
#nginx-ec2 instances security group to allow traffic from anywhere into our ec2 only through port 80
resource "aws_security_group" "nginx_sg" {
  name_prefix   = "nginx_sg"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.alb_sg.gateway_id]
  }
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
}
egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [aws_default_vpc.default.cidr_block]
}
}

resource "aws_security_group_rule" "nginx_egress_rule" {
  type = "egress"
  from_port = 0
  to_port =0 
  protocol = "-1"
  security_group_id = aws_security_group.nginx_sg.id
  cidr_blocks = [aws_default_vpc.default.cidr_block]
}


resource "aws_security_group" "alb_sg" {
  name   = "alb_sg"
  vpc_id = aws_default_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.nginx_sg.id]

  }
  tags = local.common_tags
}

#create a public subnet for NAT gateway
resource "aws_subnet" "nat_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_default_vpc.default.id
  
  tags = local.common_tags
}

#create an elastic ip for NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

#create the NAT gatewa in public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.nat_subnet.id
}

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]

  # }
  # tags = local.common_tags



#application load balancer security group to allow traffic from anywhere into our alb only through port 80
# resource "aws_security_group" "alb_sg" {
#   name   = "nginx_alb_sg"
#   vpc_id = aws_default_vpc.default.id
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     security_groups = [aws_security_group.nginx_sg.id]

#   }
#   tags = local.common_tags
# }



# resource "aws_security_group_rule" "nginx_ingress" {
#  type        = "ingress"
#   from_port   = 80
#   to_port     = 80
#   protocol    = "tcp"
#   security_group_id = aws_security_group.sg_nginx.id
#   source_security_group_id = aws_security_group.sg_alb.id
#   lifecycle {
#     ignore_changes = [
#       source_security_group_id,
#     ]
#   }
# }


resource "aws_autoscaling_group" "nginx_asg" {
  name = "nginx_asg"
  max_size = 3
  min_size = 3
  desired_capacity = 3
  health_check_grace_period  = 300
  health_check_type          = "EC2"
  vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
  launch_configuration = aws_launch_configuration.nginx.id  
} 