output "headers_lambda_name" {
  value = "${aws_lambda_function.headersLambda.function_name}"
}

output "paths_lambda_name" {
  value = "${aws_lambda_function.pathsLambda.function_name}"
}