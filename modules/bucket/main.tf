# ---------------------------------------------------------------------------------------------------------------------
# CREATE BUCKET
# The first resource creation will be run when domain is present. The second will be run when domain is absent.
# For the latter, the website properties will be appended later as required.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "bucket_with_www" {

  # If domain_name is empty, will get run 1 times
  count = "${var.domain_name != "" ? 1 : 0}"

  bucket = "${var.domain_name}"
  acl    = "private"

  tags = {
    Name        = "CloudFront S3 Origin"
    Project     = "${var.domain_name}"
    Environment = "${var.env}"
  }

  website = {
    redirect_all_requests_to = "${var.domain_name}"
  }
}

resource "aws_s3_bucket" "bucket_without_www" {

  # If domain_name is empty, will get run 1 times
  count = "${var.domain_name == "" ? 1 : 0}"

  bucket_prefix = "cloudfront-origin-"

  tags = {
    Name        = "CloudFront S3 Origin"
    Project     = "Your CloudFront distribution"
    Environment = "${var.env}"
  }

  website = {
    index_document = "index.html"
  }
  # We will apply website props later!
}