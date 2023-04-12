output "aws_instance_public_dns_ngix1" {
  value = aws_instance.nginx1.public_dns
}

output "aws_instance_public_dns_ngix2" {
  value = aws_instance.nginx2.public_dns
}

output "aws_instance_public_dns_ngix3" {
  value = aws_instance.nginx3.public_dns
}