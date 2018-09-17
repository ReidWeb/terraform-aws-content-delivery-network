# ---------------------------------------------------------------------------------------------------------------------
# CREATE BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "private_bucket" {
  bucket = "${var.domain_name}"
  acl    = "private"

  tags {
    Project     = "ReidWeb.com-Gatsby"
    Environment = "${var.env}"
  }

  website = {
    redirect_all_requests_to = "${var.domain_name}"
  }
}

