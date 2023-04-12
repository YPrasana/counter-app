1. here in this setup iam adding application load balancer to the 3 public ec2 instances which are running nginx web server.
2. additional data sources and resources we are adding are:
   Data source:"aws_availability_zones" --> list of current availability zones
   load balancer resources:
   "aws_lb" --> aws application load balancer
   "aws_lb_target_group" --> it defines a group an application load balancer can target when a request comes into it.
   "aws_lb_listener" --> to service incoming requests we need this listener that listens on port 80 for all inbound requests
   "aws_lb_target_group_attachment" --> we need to associate our target group with our 3 ec2 instances (web servers)
3. renamed  main.tf to network.tf 
4. added loadbalancer.tf file and added confg aws_lb, aws_lb_listener,aws_lb_target_group,aws-lb_target_group_attachment
5. adding security group to application load balancer which allows in http traffic only on port 80.
---------------
network.tf
6.resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}
  here we have changed the ec2 instances security group to allow the traffic from all addresses that are within vpc.
-----------------------
loadbalancer.tf
7. subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet1.id, aws_subnet.subnet1.id]-->we are associating aal the subnets of 3 ec2 instances with alb.
-----------------------
8. loadbalancer.tf
enable_deletion_protection = false --> to delete the load balancer when we are done with it.
------------------
9. in loadbalancer.tf
we adding 3 target group attachments(3 ec2) for alb .
------------------
10. about state file points to be noted:
the terraform state file is in json format
locking is possible on statefile
location: local or on cloud
workspace is also supported bt state data.
serial number is incremented each time the state data id updated.
lineage is an unique id associated with each instance of state dataand prevents terraform from updating the wrong state data associated with a config.
outputs: {}
resources:[]
commands for state data:
terraform state list
terraform state show ADDRESS--> RESOURCE TYPE AND  NAME
terraform state mv SOURCE DESTINATION--> renaming resourcs or moving them to modules
terraform state rm ADDRESSOFRESOURCE-->IF U NEED TO PURGE SOMETHING FROM THE STATE FILE (i.e) IF YOU WANT TO REMOVE A RESOURCE FROM TERRAFORM MGNT WITHOUT DESTROYING IT WE  CAN DO THAT BY REMOVING RESOURCE BLOCK FROM CONFIGURATIONAND THEN REMOVE ENTRY FROM THE STATEFILE . OTHERWISE NEXT TIME YOU RUN terraform apply U WILL ATTEMPT TO DESTORY THE DEPLOYED RESOURCE IN THE TARGET ENVIRONMENT.
--------------------
