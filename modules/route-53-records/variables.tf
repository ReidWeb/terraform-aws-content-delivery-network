# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "domain_name" {
  description = "Primary domain for this distribution. Be aware that A & AAAA records will be created in Route53 for this with target of your CloudFront distribution. If not provided, then no records will be created."
  default = ""
}

variable "route53_zone_name" {
  description = "The name of your Route 53 zone in which to create the records e.g. example.com. If absent, no records will be created."
  default = ""
}

variable "cloudfront_hosted_zone_id" {
  description = "Zone ID of cloudfront origin"
  default = ""
}

variable "cloudfront_domain" {
  description = "Cloudfront.net domain"
  default = ""
}

variable "additional_domains" {
  description = "Additional domains for this distribution. Be ware that A & AAAA records will be created in Route53 for this with a target of your CloudFront distrubution. If not provided, no additional domains will be added."
  type = "list"
  default = [""]
}