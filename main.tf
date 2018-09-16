variable "region" { default = "us-east-1" }
variable "env" {}
variable "domain_name" {}
variable "additional_domains" {
  type = "list"
}
variable "route53_zone_name" {}

module "compute" {
  source = "./modules/compute"

  domain_name = "${var.domain_name}"
  env = "${var.env}"
  region = "${var.region}"
}

module "storage" {
  source = "./modules/storage"

  domain_name = "${var.domain_name}"
  env = "${var.env}"
}

module "networking" {
  source = "./modules/networking"

  domain_name = "${var.domain_name}"
  additional_domains = "${var.additional_domains}"
  route53_zone_name = "${var.route53_zone_name}"
  env = "${var.env}"
  bucket_regional_domain_name = "${module.storage.bucket_regional_domain}"
  paths_lambda_name = "${module.compute.paths_lambda_name}"
  headers_lambda_name = "${module.compute.headers_lambda_name}"
}

module "security" {
  source = "./modules/security"

  domain_name = "${var.domain_name}"
  cloudfront_origin_iam_arn = "${module.networking.cloudfront_origin_iam_arn}"
}