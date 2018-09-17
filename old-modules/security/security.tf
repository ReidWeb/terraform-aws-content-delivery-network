variable "domain_name" {}
variable "cloudfront_origin_iam_arn" {}

module "iam" {
  source = "./iam"

  cloudfront_origin_iam_arn = "${var.cloudfront_origin_iam_arn}"
  domain_name = "${var.domain_name}"
}