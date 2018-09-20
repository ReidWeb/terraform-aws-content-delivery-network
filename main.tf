# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CDN IN AWS
# ---------------------------------------------------------------------------------------------------------------------

# Terraform 0.9.5 suffered from https://github.com/hashicorp/terraform/issues/14399, which causes this template the
# conditionals in this template to fail.
terraform {
  required_version = ">= 0.9.3, != 0.9.5"
}

provider "aws" {
  alias                   = "primary"
  region                  = "${var.region}"
  profile                 = "${var.profile}"
  shared_credentials_file = "${var.shared_credentials_file}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LAMBDAS (IF REQUIRED)
# ---------------------------------------------------------------------------------------------------------------------
module "lambdas" {
  source = "./modules/lambdas"

  domain_name       = "${var.domain_name}"
  env               = "${var.env}"
  provision_lambdas = "${var.region == "us-east-1" ? var.provision_lambdas : "false"}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE BUCKET
# ---------------------------------------------------------------------------------------------------------------------
module "bucket" {
  source = "./modules/bucket"

  domain_name = "${var.domain_name}"
  env         = "${var.env}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CERTIFICATE (IF REQUIRED)
# ---------------------------------------------------------------------------------------------------------------------
module "certificate" {
  source = "./modules/certificate"

  domain_name             = "${var.domain_name}"
  env                     = "${var.env}"
  additional_domains      = "${var.additional_domains}"
  profile                 = "${var.profile}"
  shared_credentials_file = "${var.shared_credentials_file}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE DISTRIBUTION
# ---------------------------------------------------------------------------------------------------------------------
module "cloudfront_distribution" {
  source = "./modules/cloudfront-distribution"

  domain_name                    = "${var.domain_name}"
  bucket_domain_name             = "${module.bucket.bucket_domain_name}"
  env                            = "${var.env}"
  additional_domains             = "${var.additional_domains}"
  cert_arn                       = "${module.certificate.cert_arn}"
  headers_lambda_unqualified_arn = "${module.lambdas.headers_lambda_unqualified_arn}"
  paths_lambda_unqualified_arn   = "${module.lambdas.paths_lambda_unqualified_arn}"
  headers_lambda_version         = "${module.lambdas.headers_lambda_version}"
  paths_lambda_version           = "${module.lambdas.paths_lambda_version}"
  provision_lambdas              = "${var.region == "us-east-1" ? var.provision_lambdas : "false"}"
}

# ---------------------------------------------------------------------------------------------------------------------
# APPLY POLICY TO BUCKET PERMITTING ACCESS FROM CLOUDFRONT DISTRIBUTION
# ---------------------------------------------------------------------------------------------------------------------
module "bucket_iam_policy" {
  source = "./modules/bucket-iam-policy"

  bucket_arn                = "${module.bucket.bucket_arn}"
  bucket_id                 = "${module.bucket.bucket_id}"
  cloudfront_origin_iam_arn = "${module.cloudfront_distribution.cloudfront_origin_iam_arn}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE 53 RECORDS
# ---------------------------------------------------------------------------------------------------------------------
module "route_53_records" {
  source = "./modules/route-53-records"

  additional_domains        = "${var.additional_domains}"
  route53_zone_name         = "${var.route53_zone_name}"
  cloudfront_domain         = "${module.cloudfront_distribution.cloudfront_domain}"
  domain_name               = "${var.domain_name}"
  cloudfront_hosted_zone_id = "${module.cloudfront_distribution.cloudfront_dist_zone_id}"
}
