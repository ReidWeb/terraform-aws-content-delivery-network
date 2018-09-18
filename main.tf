# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CDN IN AWS
# ---------------------------------------------------------------------------------------------------------------------

# Terraform 0.9.5 suffered from https://github.com/hashicorp/terraform/issues/14399, which causes this template the
# conditionals in this template to fail.
terraform {
  required_version = ">= 0.9.3, != 0.9.5"
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE LAMBDAS (IF REQUIRED)
# ---------------------------------------------------------------------------------------------------------------------
module "lambdas" {
  source = "./modules/lambdas"

  domain_name = "${var.domain_name}"
  env = "${var.env}"
  provision_lambdas = "${var.provision_lambdas}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE BUCKET
# ---------------------------------------------------------------------------------------------------------------------
module "bucket" {
  source = "./modules/bucket"

  domain_name = "${var.domain_name}"
  env = "${var.env}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CERTIFICATE (IF REQUIRED)
# ---------------------------------------------------------------------------------------------------------------------
module "certificate" {
  source = "./modules/certificate"

  domain_name = "${var.domain_name}"
  env = "${var.env}"
  additional_domains = "${var.additional_domains}"
}
//
//module "storage" {
//  source = "./modules/storage"
//
//  domain_name = "${var.domain_name}"
//  env = "${var.env}"
//}
//
//module "networking" {
//  source = "./modules/networking"
//
//  domain_name = "${var.domain_name}"
//  additional_domains = "${var.additional_domains}"
//  route53_zone_name = "${var.route53_zone_name}"
//  env = "${var.env}"
//  bucket_regional_domain_name = "${module.storage.bucket_regional_domain}"
//  paths_lambda_name = "${module.compute.paths_lambda_name}"
//  headers_lambda_name = "${module.compute.headers_lambda_name}"
//}
//
//module "security" {
//  source = "./modules/security"
//
//  domain_name = "${var.domain_name}"
//  cloudfront_origin_iam_arn = "${module.networking.cloudfront_origin_iam_arn}"
//}