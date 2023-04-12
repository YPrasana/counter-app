locals {
  common_tags = {
    company      = var.company
    project      = "${var.company}-${var.project}"
    billing_code = "${var.workspace}-${var.billing_code}"
  }
}