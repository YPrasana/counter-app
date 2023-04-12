#networking#
#1. default vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = local.common_tags
}

#2. Create Internet Gateway that associates with default vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags
}

#3. create 3 public subnets 

resource "aws_subnet" "subnet1" {
  cidr_block              = var.vpc_subnets_cidr_block[0]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = local.common_tags
}

resource "aws_subnet" "subnet2" {
  cidr_block              = var.vpc_subnets_cidr_block[1]
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = local.common_tags
}

resource "aws_subnet" "subnet3" {
  cidr_block              = var.vpc_subnets_cidr_block[2]
  availability_zone       = data.aws_availability_zones.available.names[2]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = local.common_tags
  
}

#routing#
#4. create the route table and associate the route table with vpc
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
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

#security groups#
#nginx-ec2 instances security group to allow traffic from anywhere into our ec2 only through port 80
resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = local.common_tags

}

#application load balancer security group to allow traffic from anywhere into our alb only through port 80
resource "aws_security_group" "alb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.vpc.id
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
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = local.common_tags

}
