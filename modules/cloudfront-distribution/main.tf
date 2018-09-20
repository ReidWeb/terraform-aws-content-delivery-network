resource "aws_cloudfront_origin_access_identity" "orig_access_ident" {
  comment = "CloudFront Origin Access Identity to access S3 Bucket ${var.domain_name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDFRONT DIST WITH CUSTOM DOMAIN AND LAMBDAS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "dist_with_domain_and_lambdas" {

  provider = "aws.primary"

  # Only provision if proivion_lambdas is not false, and domain_name is not an empty strings
  count = "${var.provision_lambdas != "false" ? var.domain_name  !=  "" ? 1 : 0 : 0}"

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
  comment = "Cloudfront distribution for ${var.env} environment"

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
      lambda_arn = "${var.headers_lambda_unqualified_arn}:${var.headers_lambda_version}"
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${var.paths_lambda_unqualified_arn}:${var.paths_lambda_version}"
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

  tags = {
    Name        = "CloudFront Distribution"
    Project     = "${var.domain_name}"
    Environment = "${var.env}"
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    acm_certificate_arn = "${var.cert_arn}"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDFRONT DIST WITH LAMBDAS BUT NO CUSTOM DOMAIN
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "dist_with_lambdas_with_no_custom_domain" {

  # Only provision if proivion_lambdas IS NOT false, and domain_name IS an empty strings
  # Only provision if proivion_lambdas IS NOT false, and domain_name IS an empty strings
  count = "${var.provision_lambdas != "false" ? var.domain_name  ==  "" ? 1 : 0 : 0}"

  // origin is where CloudFront gets its content from.
  origin {
    // We need to set up a "custom" origin because otherwise CloudFront won't
    // redirect traffic from the root domain to the www domain, that is from
    // runatlantis.io to www.runatlantis.io.
    // Here we're using our S3 bucket's URL!
    domain_name = "${var.bucket_regional_domain_name}"
    // This can be any name to identify this origin.
    origin_id   = "S3-origin"


    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.orig_access_ident.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version = "http2"
  default_root_object = "index.html"
  comment = "Cloudfront distribution for ${var.env} environment"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    // This needs to match the `origin_id` above.
    target_origin_id       = "S3-origin"
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
          lambda_arn = "${var.headers_lambda_unqualified_arn}:${var.headers_lambda_version}"
        }

        lambda_function_association {
          event_type = "origin-request"
          lambda_arn = "${var.paths_lambda_unqualified_arn}:${var.paths_lambda_version}"
        }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "CloudFront Distribution"
    Project     = "Your CloudFront distribution"
    Environment = "${var.env}"
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDFRONT DIST WITH CUSTOM DOMAIN BUT NO LAMBDAS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "dist_with_custom_domain_with_no_lambdas" {

  # Only provision if proivion_lambdas is not false, and domain_name is not an empty strings
  count = "${var.provision_lambdas == "false" ? var.domain_name  !=  "" ? 1 : 0 : 0}"

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
  comment = "Cloudfront distribution for ${var.env} environment"

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

  }

  // Here we're ensuring we can hit this distribution using www.runatlantis.io
  // rather than the domain name CloudFront gives us.
  aliases = ["${var.domain_name}","${var.additional_domains}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "CloudFront Distribution"
    Project     = "${var.domain_name}"
    Environment = "${var.env}"
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    acm_certificate_arn = "${var.cert_arn}"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDFRONT DIST WITH NO LAMBDAS AND NO CUSTOM DOMAIN
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "dist_with_no_custom_domain_with_no_lambdas" {

  # Only provision if proivion_lambdas is not false, and domain_name is not an empty strings
  count = "${var.provision_lambdas == "false" ? var.domain_name  ==  "" ? 1 : 0 : 0}"

  // origin is where CloudFront gets its content from.
  origin {
    // We need to set up a "custom" origin because otherwise CloudFront won't
    // redirect traffic from the root domain to the www domain, that is from
    // runatlantis.io to www.runatlantis.io.
    // Here we're using our S3 bucket's URL!
    domain_name = "${var.bucket_regional_domain_name}"
    // This can be any name to identify this origin.
    origin_id   = "S3-origin"


    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.orig_access_ident.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version = "http2"
  default_root_object = "index.html"
  comment = "Cloudfront distribution for ${var.env} environment"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    // This needs to match the `origin_id` above.
    target_origin_id       = "S3-origin"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "CloudFront Distribution"
    Project     = "Your CloudFront distribution"
    Environment = "${var.env}"
  }

  // Here's where our certificate is loaded in!
  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}