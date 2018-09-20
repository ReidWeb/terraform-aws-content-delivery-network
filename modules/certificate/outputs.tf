output "cert_arn" {
  description = "The ARN of the certificate."
  value       = "${element(concat(aws_acm_certificate_validation.certificate.*.certificate_arn, list("")), 0)}"
}

output "cert_id" {
  description = "The ID of the certificate."
  value       = "${element(concat(aws_acm_certificate.certificate.*.id, list("")),0)}"
}
