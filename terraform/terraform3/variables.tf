variable "aws_access_key" {
  type        = string
  description = "access_key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "secret_key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "region to be used while creating resources"
  default     = "ap-southeast-1"
  sensitive   = false
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable_dns_hostnames in vpc"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "enable_dns_support in vpc"
  default     = true
}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "cidr block for all 3 subnets in vpc"
  default     = ["172.31.6.0/24", "172.31.7.0/24", "172.31.8.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "getting public_ip on ec2 launch"
  default     = true
}

variable "rtb_cidr_block" {
  type        = string
  description = "cidr block for route table to traffic gets out of vpc "
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  type        = string
  description = "type of instance"
  default     = "t2.micro"
}

variable "billing_code" {
  type        = string
  description = "the billing code to provision the infra from cloud"
  default     = "X101"
}


variable "company" {
  type        = string
  description = "client name"
  default     = "toppan"
}

#this project is value is given during runtime
variable "project" {
  type        = string
  description = "project name for resource tagging"
}

#specify this variable value also during run time
variable "workspace" {
  type        = string
  description = "specify the work environment"
}