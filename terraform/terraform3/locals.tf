resource "random_integer" "random" {
  min = 10000
  max = 99999
}

locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = "${var.workspace}-${var.billing_code}"
  }

  #giving name to s3 bucket dynamically
  s3_bucket_name = "projecttoppan-${random_integer.random.result}"
}

