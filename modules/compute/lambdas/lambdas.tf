variable "env" {}
variable "domain_name" {}
variable "region" {}

locals {
  underscored_domain = "${replace(var.domain_name, ".", "_")}"
  lambda_base_name = "cloudFront-${local.underscored_domain}-${var.env}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambdaPolicy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}


resource "aws_iam_role" "main" {
  name = "${local.lambda_base_name}-${var.region}-lambdaRole"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaPolicy.json}"
}

data "template_file" "log_policy_template" {
  template = "${file("${path.module}/logging_policy.json")}"

  vars {
    region = "${var.region}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    lambda_name = "${local.lambda_base_name}"
  }
}

resource "aws_iam_policy" "log_policy" {
  name        = "${local.lambda_base_name}-log-pol"
  path        = "/"
  description = "Policy permitting lambdas to log to CloudWatch"

  policy = "${data.template_file.log_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "logging-attach" {
  role       = "${aws_iam_role.main.name}"
  policy_arn = "${aws_iam_policy.log_policy.arn}"
}

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