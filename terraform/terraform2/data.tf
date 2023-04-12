#data resources #
#service manager parameter
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#declare availability zone data source
data "aws_availability_zones" "available" {
  state = "available"
}