variable "domain_name" {}
variable "cloudfront_origin_iam_arn" {}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/bucket_policy.json")}"

  vars {
    bucket = "${var.domain_name}"
    iam_arn= "${var.cloudfront_origin_iam_arn}"
  }
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.domain_name}"
  policy = "${data.template_file.bucket_policy.rendered}"
}