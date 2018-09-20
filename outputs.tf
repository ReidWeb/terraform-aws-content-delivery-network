output "headers_lambda_qualified_arn," {
  value = "${module.lambdas.headers_lambda_unqualified_arn}"
  description = "Qualified ARN of headers Lambda"
}

output "paths_lambda_qualified_arn," {
  value = "${module.lambdas.paths_lambda_unqualified_arn}"
  description = "Qualified ARN of paths Lambda"
}

output "lambda_role_arn" {
  value = "${module.lambdas.lambda_role_arn}"
  description = "ARN of role assigned to Lambdas"
}

output "bucket_id" {
  value = "${module.bucket.bucket_id}"
  description = "ID for Origin S3 Bucket"
}

output "bucket_regional_domain_name" {
  value = "${module.bucket.bucket_regional_domain_name}"
  description = "Regional domain name for Origin S3 Bucket"
}

output "certificate_id" {
  value = "${module.certificate.cert_id}"
  description = "ID of certfificate provisioned in ACM"
}

output "certificate_arn" {
  value = "${module.certificate.cert_arn}"
  description = "ARN of certificate provisioned in ACM"
}

output "cloudfront_dist_zone_id" {
  value = "${module.cloudfront_distribution.cloudfront_dist_zone_id}"
  description = "Zone ID of CloudFront Distribution"
}

output "cloudfront_domain" {
  value = "${module.cloudfront_distribution.cloudfront_domain}"
  description = ".cloudfront.net domain of Distribution"
}

output "cloudfront_origin_iam_arn" {
  value = "${module.cloudfront_distribution.cloudfront_origin_iam_arn}"
  description = "CloudFront Origin Acess Identity"
}