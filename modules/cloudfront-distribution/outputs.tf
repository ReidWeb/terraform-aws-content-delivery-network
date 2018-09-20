output "cloudfront_dist_zone_id" {
  value = "${element(
                      concat(
                            compact(
                                    concat(
                                      aws_cloudfront_distribution.dist_with_custom_domain_with_no_lambdas.*.hosted_zone_id,
                                      aws_cloudfront_distribution.dist_with_domain_and_lambdas.*.hosted_zone_id,
                                      aws_cloudfront_distribution.dist_with_lambdas_with_no_custom_domain.*.hosted_zone_id,
                                      aws_cloudfront_distribution.dist_with_no_custom_domain_with_no_lambdas.*.hosted_zone_id
                                    )
                                   ),
                                   list("")
                            ),
                      0
                    )}"

  description = "The Zone ID of the CloudFront distribution ("
}

output "cloudfront_domain" {
  value = "${element(
                      concat(
                            compact(
                                    concat(
                                      aws_cloudfront_distribution.dist_with_custom_domain_with_no_lambdas.*.domain_name,
                                      aws_cloudfront_distribution.dist_with_domain_and_lambdas.*.domain_name,
                                      aws_cloudfront_distribution.dist_with_lambdas_with_no_custom_domain.*.domain_name,
                                      aws_cloudfront_distribution.dist_with_no_custom_domain_with_no_lambdas.*.domain_name
                                    )
                                   ),
                                   list("")
                            ),
                      0
                    )}"

  description = "[x].cloudfront.net domain name of CloudFront distribution"
}

output "cloudfront_origin_iam_arn" {
  value       = "${aws_cloudfront_origin_access_identity.orig_access_ident.iam_arn}"
  description = "CloudFront origin ARN"
}
