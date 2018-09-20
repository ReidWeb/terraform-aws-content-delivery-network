
// Over write user provided region - CloudFront can only source certificates from us-east-1 ACM
provider "aws" {
  alias = "virginia"
  region = "us-east-1"
  profile = "${var.profile}"
  shared_credentials_file = "${var.shared_credentials_file}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE CERTIFICATE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_acm_certificate" "certificate" {

  provider = "aws.virginia"

  # If domain_name is absent, will get run 0 times
  count = "${var.domain_name != "" ? 1 : 0}"

  domain_name       = "${var.domain_name}"
  validation_method = "EMAIL"

  subject_alternative_names = "${var.additional_domains}"

  tags = {
    Name        = "CloudFront Distribution Certificate"
    Project     = "${var.domain_name}"
    Environment = "${var.env}"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# WAIT FOR CERTIFICATE TO COMPLETE VALIDATION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_acm_certificate_validation" "certificate" {
  provider = "aws.virginia"

  # If domain_name is absent, will get run 0 times
  count = "${var.domain_name != "" ? 1 : 0}"

  certificate_arn = "${aws_acm_certificate.certificate.0.arn}"
}

