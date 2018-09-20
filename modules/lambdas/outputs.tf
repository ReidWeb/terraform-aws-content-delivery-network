output "headers_lambda_qualified_arn" {
  value = "${element(concat("${aws_lambda_function.headersLambda.arn}:${aws_lambda_function.function.headersLambda.version}", list("")),0)}"
  description = "Qualified ARN of headers Lambda"
}

output "paths_lambda_qualified_arn" {
  value = "${element(concat("${aws_lambda_function.pathsLambda.arn}:${aws_lambda_function.function.pathsLambda.version}", list("")),0)}"
  description = "Qualified ARN of paths Lambda"
}

output "lambda_role_arn" {
  value = "${module.lambda_iam_role.role_arn}"
  description = "ARN of role assigned to Lambdas"
}