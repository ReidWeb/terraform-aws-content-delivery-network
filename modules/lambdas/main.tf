locals {
  underscored_domain = "${replace(var.domain_name, ".", "_")}"
  lambda_base_name =  "cloudFront-${local.underscored_domain}"
  lambda_base_name_with_env = "${local.lambda_base_name}-${var.env}"
  headers_lambda_name = "cloudFront-${local.lambda_base_name}-headers-${local.underscored_domain}-${var.env}"
  paths_lambda_name = "cloudFront-${local.lambda_base_name}-paths-${local.underscored_domain}-${var.env}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE LAMBDA ROLE
# ---------------------------------------------------------------------------------------------------------------------
module "lambda_iam_role" {
  source = "../lambda-iam-role"
  region = "us-east-1"
  lambda_base_name_with_env = "${local.lambda_base_name_with_env}"
  paths_lambda_name = "${local.paths_lambda_name}"
  headers_lambda_name = "${local.headers_lambda_name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE HEADERS LAMBDA
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lambda_function" "headersLambda" {
  function_name = "${local.headers_lambda_name}"

  filename = "${"${path.module}/headers.zip"}"
  handler = "headers.handler"
  runtime = "nodejs8.10"
  description = "Lambda function to process events when CloudFront receives a response from the origin to add headers"

  role = "${module.lambda_iam_role.role_arn}"

  tags = {
    Name        = "Headers Lambda"
    Project     = "${var.domain_name}"
    Environment = "${var.env}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE PATHS LAMBDA
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lambda_function" "pathsLambda" {
  function_name = "${local.paths_lambda_name}"

  filename = "${"${path.module}/paths.zip"}"
  handler = "paths.handler"
  runtime = "nodejs8.10"
  description = "Lambda function to process events when CloudFront requests a response from Cloudfront in order to redirect"

  role = "${module.lambda_iam_role.role_arn}"

  tags = {
    Name        = "Paths Lambda"
    Project     = "${var.domain_name}"
    Environment = "${var.env}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE LAMBDA ALIASES/VERSIONS
# ---------------------------------------------------------------------------------------------------------------------
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

