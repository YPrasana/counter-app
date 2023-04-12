1.In this first configuration iam creating a default vpc with default subnets and default routing table .
2.security group of incoming 80 and outgoing all.
3.ec2 instances in 3 availability zones (sg)(running nginx on booting.)

explanation: for availability_zone = data.aws_availability_zones.available.names[count.index] in main.tf
------------
The count.index expression inside the aws_subnet resource refers to the current index of the resource being created.
Since we have a count of 3 for the aws_subnet resource, the count.index variable will take on values of 0, 1, and 2 for each resource instance created.
By using the count.index variable to index into the data.aws_availability_zones.available.names list, we can assign each aws_subnet resource to a different availability zone. 
For example, the first aws_subnet resource will be assigned to the first availability zone in the list, the second aws_subnet resource will be assigned to the second availability zone, and so on.

explanation for : map_public_ip_on_launch = true in main.tf
---------------
When this parameter is set to true, any new instances launched in the subnet will be automatically assigned a public IP address.
In AWS, by default, instances launched in a subnet do not get a public IP address. 
This means that if you want to access your instances from the internet, you need to configure a NAT gateway or a bastion host to provide connectivity. 
However, by setting map_public_ip_on_launch to true, you can simplify this process and directly access your instances from the internet.
------------------
syntax: for variable:
variable "name" {
    type = value-->(string,bool,number(num or decimal))
    description = "write description of the variable and purpose"
    default = "value"--> (provide the -var="name"="value" at terraform execution time other wise will take this default value if not provided)
    sensitive = true or false
}
eg:variable "aws_region" {
    type = string --> string type var
    description = "region to be used while creating resources"
    default = "ap-southeast-1" --> its value to be taken by default if not provided at runtime
    sensitive = false --> that means we can see the value on console if it is set false then we cannot view that run time if given
}
reference to the above variable:
var.aws_region
-------------------
datatypes we use generally in terraform:
1.primitive: string, number, boolean
2.collection: list(for ordered group of elements), set(for unordered group of elements),map(set of key: value pairs).
3.structural: tuple, objects.
eg:
string:
type = string
value = "name"
boolean:
type = bool
value = true
list:
[1, 2, 3, 4] 
["us-east-1", "us-east-2"]
map:
{
    small = "t2.micro"
    medium = "t2.small"
}
------------------------------
here iam setting my aws credentials as env variables
eg:$env:TF_VAR_aws_access_key="your access key"
   $env:TF_VAR_aws_secret_key="your secret key"
for linux: use below:
eg: export TF_VAR_aws_access_key=your access key
    export:TF_VAR_aws_secret_key=your secret key
------------------------------------
else we can pass the credentials at run time like other variables but not recommended.
eg:terraform plan -var=aws_access_key="your access key" -var=aws_secret_key="your secret key"
--------------------------------------
workflow:
#create new workspace: 
terraform workspace list
terraform workspace new development
terraform init
terraform fmt
terraform validate
terraform plan -out "terraform1.tfplan"
terraform apply "terraform1.tfplan"
