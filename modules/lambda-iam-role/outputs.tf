output "role_arn" {
  description = "ARN of role created for use by Lambdas"
  value = "${aws_iam_role.main.arn}"
}