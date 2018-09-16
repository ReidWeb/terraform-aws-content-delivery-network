variable "env" { }
variable "domain_name" {}

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

output "bucket_id" { value = "${aws_s3_bucket.private_bucket.id}" }
output "bucket_regional_domain_name" { value = "${aws_s3_bucket.private_bucket.bucket_regional_domain_name}" }