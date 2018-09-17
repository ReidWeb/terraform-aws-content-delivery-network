variable "env" {}
variable "domain_name" {}
variable "region" {}

resource "aws_lambda_function" "headersLambda" {
  function_name = "headers-${local.lambda_base_name}"

  filename = "${"${path.module}/headers.zip"}"
  handler = "headers.handler"
  runtime = "nodejs8.10"
  description = "Lambda function to process events when CloudFront receives a response from the origin to add headers"

  role = "${aws_iam_role.main.arn}"
}

resource "aws_lambda_function" "pathsLambda" {
  function_name = "paths-${local.lambda_base_name}"

  filename = "${"${path.module}/paths.zip"}"
  handler = "paths.handler"
  runtime = "nodejs8.10"
  description = "Lambda function to process events when CloudFront requests a response from the origin to redirect"

  role = "${aws_iam_role.main.arn}"
}


resource "aws_lambda_alias" "headersLambdaAlias" {
  name             = "STABLE"
  function_name    = "${aws_lambda_function.headersLambda.arn}"
  function_version = "1"
}

resource "aws_lambda_alias" "pathsLambdaAlias" {
  name             = "STABLE"
  function_name    = "${aws_lambda_function.pathsLambda.arn}"
  function_version = "1"
}

output "headers_lambda_name" {
  value = "${aws_lambda_function.headersLambda.function_name}"
}

output "paths_lambda_name" {
  value = "${aws_lambda_function.pathsLambda.function_name}"
}