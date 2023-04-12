# aws_s3_bucket #
resource "aws_s3_bucket" "web_bucket" {
    bucket             = local.s3_bucket_name
    force_destroy      = true

    tags = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "web_bucket" {
  bucket = aws_s3_bucket.web_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "web_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.web_bucket]
  
  bucket = aws_s3_bucket.web_bucket.id
  acl = "private"
}

#aws_s3_bucket_object #
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.web_bucket.bucket
    key    = "/website/index.html"
    source = "./website/index.html"
    content_type = "text/html"

    tags = local.common_tags
}


resource "aws_s3_object" "style" {
    bucket = aws_s3_bucket.web_bucket.bucket
    key    = "/website/style.css"
    source = "./website/style.css"
    content_type = "text/css"


    tags = local.common_tags
}

resource "aws_s3_object" "app" {
    bucket = aws_s3_bucket.web_bucket.bucket
    key    = "/website/app.js"
    source = "./website/app.js"
    content_type = "application/javascript"

    tags = local.common_tags
}

# aws_iam_role: HERE ASSUME_ROLE_POLICY grants an entity permission to assume the role.
resource "aws_iam_role" "nginx_s3_role" {
    name = "nginx_s3_role"

    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17"
        "Statement": [
            {
                "Action": "sts:AssumeRole"
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                }
                "Effect": "Allow",
                "Sid": " "
            }
        ]
    }
    EOF
    tags = local.common_tags
}

# create ec2 instance profile which links the above iam_role to ec2 instances
resource "aws_iam_instance_profile" "nginx_profile" {
    name = "nginx_profile"
    role = "${aws_iam_role.allow_nginx_s3.name}"
    
tags = local.common_tags
}


#now adding iam policies to give full access to private s3 bucket which we had created.

# aws_iam_role_policy this actually grants permissions to access the s3 bucket and also assign this policy to the aws_iam_role#
resource "aws_iam_policy" "nginx_s3_policy" {
    name = "nginx_s3_policy"
    role = "${aws_iam_role.nginx_s3_role.id}"

    policy = <<EOF
   {
    "Version": "2012-10-17"
    "Statement": [
        {
            "Action": ["s3:*"],
            "Effect": "Allow",
            "Resource": "*"
         }
    ]
}
EOF
}


    




# # aws_iam_instance_profile we assign this profile to our ec2 instances#
# resource "aws_iam_instance_profile" "nginx_profile" {
#     name = "nginx_profile"
#     role = "${aws_iam_role.allow_nginx_s3.name}"
    
# tags = local.common_tags
# }