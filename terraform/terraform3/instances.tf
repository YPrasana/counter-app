#launch configuration#
resource "aws_launch_configuration" "nginx" {
  name_prefix = "nginx"
  image_id = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type = "t2.micro"
  #depends_on = [aws_iam_policy.allow_s3_all]
  iam_instance_profile = "${aws_iam_instance_profile.nginx_profile.name}"
  security_groups = ["${aws_security_group.nginx_sg.id}"]
  user_data = "${data.template_file.user_data.rendered}"
  lifecycle {
    create_before_destroy = true
  }
  depends_on = ["aws_s3_bucket.web_bucket"]
  }
