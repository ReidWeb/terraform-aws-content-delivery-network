output "role_arn" {
  description = "ARN of role created for use by Lambdas"
  value       = "${element(concat(aws_iam_role.main.*.arn, list("")),0)}"
}
