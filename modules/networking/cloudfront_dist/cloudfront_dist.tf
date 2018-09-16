variable "domain_name" {}
variable "cert_arn" {}
variable "env" {}
variable "bucket_regional_domain_name" {}
variable "additional_domains" { type = "list"}
variable "paths_lambda_name" {}
variable "headers_lambda_name" {}

data "aws_lambda_function" "cloudFrontHeadersLambda" {
  function_name = "${var.headers_lambda_name}"
  qualifier = "STABLE"
}

data "aws_lambda_function" "cloudFrontPathsLambda" {
  function_name = "${var.paths_lambda_name}"
  qualifier = "STABLE"
}

resource "aws_cloudfront_origin_access_identity" "orig_access_ident" {
  comment = "CloudFront Origin Access Identity to access S3 Bucket ${var.domain_name}"
}

resource "aws_cloudfront_distribution" "dist" {
  // origin is where CloudFront gets its content from.
  origin {
    // We need to set up a "custom" origin because otherwise CloudFront won't
    // redirect traffic from the root domain to the www domain, that is from
    // runatlantis.io to www.runatlantis.io.
    // Here we're using our S3 bucket's URL!
    domain_name = "${var.bucket_regional_domain_name}"
    // This can be any name to identify this origin.
    origin_id   = "S3-${var.domain_name}"


    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.orig_access_ident.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version = "http2"
  default_root_object = "index.html"
  comment = "Gatsby cloudfront distribution for ${var.env} environment"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    // This needs to match the `origin_id` above.
    target_origin_id       = "S3-${var.domain_name}"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-response"
      lambda_arn = "${data.aws_lambda_function.cloudFrontHeadersLambda.qualified_arn}"
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${data.aws_lambda_function.cloudFrontPathsLambda.qualified_arn}"
    }
  }

  // Here we're ensuring we can hit this distribution using www.runatlantis.io
  // rather than the domain name CloudFront gives us.
  aliases = ["${var.domain_name}","${var.additional_domains}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Project     = "ReidWeb.com-Gatsby"
    Environment = "${var.env}"
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    acm_certificate_arn = "${var.cert_arn}"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

output "cloudfront_dist_zone_id" { value = "${aws_cloudfront_distribution.dist.hosted_zone_id}" }
output "cloudfront_domain" { value = "${aws_cloudfront_distribution.dist.domain_name}" }
output "cloudfront_origin_iam_arn" { value = "${aws_cloudfront_origin_access_identity.orig_access_ident.iam_arn}" }