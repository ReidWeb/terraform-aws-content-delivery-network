variable "domain_name" {}
variable "additional_domains" { type = "list"}
variable "route53_zone_name" {}
variable "env" {}

// Over write user provided region - CloudFront can only source certificates from us-east-1 ACM
provider "aws" {
  region = "us-east-1"
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = "${var.domain_name}"
  validation_method = "EMAIL"

  subject_alternative_names = "${var.additional_domains}"

  tags {
    Project     = "ReidWeb.com-Gatsby"
    Environment = "${var.env}"
  }
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn = "${aws_acm_certificate.certificate.arn}"
  validation_record_fqdns = ["${var.domain_name}","${var.additional_domains}"]
}

output "cert_arn" {
  description = "The ARN of the certificate."
  value       = "${aws_acm_certificate_validation.certificate.certificate_arn}"
}

output "cert_id" {
  description = "The ID of the certificate."
  value       = "${aws_acm_certificate.certificate.id}"
}