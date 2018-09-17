output "headers_lambda_qualified_arn," {
  value = "${aws_lambda_alias.headersLambdaAlias.arn}"
  description = "Qualified ARN of headers Lambda"
}

output "paths_lambda_qualified_arn," {
  value = "${aws_lambda_alias.pathsLambdaAlias.arn}"
  description = "Qualified ARN of paths Lambda"
}

output "lambda_role_arn" {
  value = "${module.lambda_iam_role.role_arn}"
  description = "ARN of role assigned to Lambdas"
}