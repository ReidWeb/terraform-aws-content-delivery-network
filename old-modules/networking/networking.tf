variable "domain_name" {}
variable "route53_zone_name" {}
variable "additional_domains" { type = "list"}
variable "env" {}
variable "bucket_regional_domain_name" {}
variable "dns_ttl" { default = 60}
variable "paths_lambda_name" {}
variable "headers_lambda_name" {}

module "certificate" {
  source = "./certificate"

  domain_name = "${var.domain_name}"
  additional_domains = "${var.additional_domains}"
  route53_zone_name = "${var.route53_zone_name}"
  env = "${var.env}"
}

module "cloudfront_dist" {
  source = "./cloudfront_dist"

  domain_name = "${var.domain_name}"
  cert_arn = "${module.certificate.cert_arn}"
  env = "${var.env}"
  bucket_regional_domain_name = "${var.bucket_regional_domain_name}"
  additional_domains = "${var.additional_domains}"
  paths_lambda_name = "${var.paths_lambda_name}"
  headers_lambda_name = "${var.headers_lambda_name}"
}

module "route53_record" {
  source = "./route53_record"

  domain_name = "${var.domain_name}"
  route53_zone_name = "${var.route53_zone_name}"
  cloudfront_hosted_zone_id = "${module.cloudfront_dist.cloudfront_dist_zone_id}"
  cloudfront_domain = "${module.cloudfront_dist.cloudfront_domain}"
  additional_domains = "${var.additional_domains}"
  dns_ttl = "${var.dns_ttl}"
}

output "cloudfront_origin_iam_arn" { value = "${module.cloudfront_dist.cloudfront_origin_iam_arn}" }