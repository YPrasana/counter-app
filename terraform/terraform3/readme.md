1.here we are adding s3 bucket and upload web content to it 
2.Then will assign ec2 instances a profile that has access to copy contentt from s3 bucket.
3.adding random provider which will generate the unique name to s3 bucket globally.
4. terraform providers we will get from public and private registries
5. plugins will be part of any of these types:(offical, verified and community open source).
6. with in your configuration you can invoke multiple instances of same provider and refer to each instance by an alias.
eg: aninstance of aws provider is limited to one region and account. if you want to use more than one region in a configuration we can do so with multiple instances of aws provider and aliases
7. removed aws_access-key and secret_key in aws_provider block and in cariables.tf file as it is given as environment variable.
8. added random provider in providers.tf and also added resource random_integer in locals.tf
9. resources created in this folder terraform 3:
->random_integer in locals.tf
#s3 resources#
->aws_s3_bucket
->aws_s3_bucket_object: (objects in s3 bucket)
#iam resources#
our ec2 instances will need access to the s3 bucket but we don't want to make bucket public. we need private  for that we create some iam resources to help us grant access to ec2 instances.
->aws_iam_role: ( for ec2 2instances)
->aws_iam_role_policy: (role policy for s3 bucket access (i.e) granting the iam role permissions to the s3 bucket by using this iam policy).
->aws_iam_instance_profile: (we assign the iam role to ec2 instances by creatingan these profiles and then adding entry to aws_instances block to use that instance profile).
during terraform planning:
1.it will refresh and inspect state file
2. make a dependency graph based on data.tf and resources 
3. then do additions, updates and deletions based on the configuration.
4. parallel execution of changes that are not dependent on other changes are done.
eg:
dependencies are created based on references.in our present configuration
aws_vpc->aws_subnet->aws_instance
aws_iam_role->aws_iam_instance_profile and aws_iam_role_policy
aws_iam_instance_profile-> aws_instance
aws_iam_role_policy->aws_instances for this we explicitly add a depends_on argument to aws_instance resource .
->congiguration options: ansible, chef, puppet or terraform provisioner
provisioner type:
1. file provisioner type: will create files and directories on a remote system
2. local-exec provisioner type : will alloe us to run a script on local machine
3. remote-exec: will allow us to run a script on remote server.
we can replace this provisioner type will startup script like which we give in userdata.
eg: for file provisioner type:
provisioner "file" {
    connection {
        type = "ssh"
        user = "root"
        private_key = var.private_key
        host = self.public_ip
    }
    source = "/local/path/to/file.txt"
    destination = "/path/to/file.txt"
}
eg:for local-exec provisioner type:
provisioner "local-exec" {
    command = "local command here"
}
eg: for remote-exec provisioner type:
provisioner "remote-exec" {
    scripts = ["list", "of", "scripts"]
}

note: the amazon cli automatically use the instance profile that has been associated with the ec2 instance to authenticate to s3 bucket

if you want to allow the instances in the private subnet to access the internet or other resources outside of the VPC, you will need to set up a NAT gateway or NAT instance in a public subnet, and update the routing tables to route traffic through the NAT gateway/instance.

In the above code, we first create a public subnet for the NAT gateway using the aws_subnet resource. We then create an elastic IP address using the aws_eip resource, which we will associate with the NAT gateway.

Next, we create the NAT gateway itself using the aws_nat_gateway resource. This resource takes in the allocation ID of the elastic IP address and the subnet ID of the public subnet.

Finally, we update the routing tables for the private subnet to route traffic through the NAT gateway. We do this by creating an aws_route_table_association resource that associates the private subnet with the private route table. We then create an aws_route resource that sets the destination CIDR block to 0.0.0.0/0 (which means all traffic) and the NAT gateway ID to the ID of the NAT gateway we created earlier. This will ensure that any traffic from the private subnet destined for the internet or other external resources will be routed through the NAT gateway.

