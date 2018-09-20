output "headers_lambda_unqualified_arn" {
  value = "${element(concat(aws_lambda_function.headersLambda.*.arn, list("")),0)}"
  description = "UnQualified ARN of headers Lambda"
}

output "paths_lambda_unqualified_arn" {
  value = "${element(concat(aws_lambda_function.pathsLambda.*.arn, list("")),0)}"
  description = "UnQualified ARN of paths Lambda"
}

output "lambda_role_arn" {
  value = "${module.lambda_iam_role.role_arn}"
  description = "ARN of role assigned to Lambdas"
}

output "paths_lambda_version" {
  value = "${element(concat(aws_lambda_function.pathsLambda.*.version, list("")),0)}"
  description = "Last published version of paths lambda"
}

output "headers_lambda_version" {
  value = "${element(concat(aws_lambda_function.headersLambda.*.version, list("")),0)}"
  description = "Last published version of headers lambda"
}