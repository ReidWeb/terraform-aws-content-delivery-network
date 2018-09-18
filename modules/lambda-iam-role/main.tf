# Load in the AWS account info, so we can use the account ID in file templates
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  underscored_domain = "${replace(var.domain_name, ".", "_")}"
  text_neded_in_role = "cloudFront-${var.env}-${data.aws_region.current.name}-lambdaRole"
  unusable_chars_for_domain = "${length(local.text_neded_in_role)}"
  usable_chars_for_domain = "${63 - local.unusable_chars_for_domain}"
  shortened_domain_name = "${substr(local.underscored_domain, 0, min(length(local.underscored_domain),local.usable_chars_for_domain))}"
  short_lambda_base_name = "cloudFront-${local.shortened_domain_name}-lambdaRole"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE INVOCATION POLICY
# We need to permit the lambda be used @Edge as well as in the traditional manner.
# ---------------------------------------------------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A ROLE WITH ABOVE POLICY INLINE
# We now need to create a role that can be used with the above policy
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "main" {
  name = "${local.short_lambda_base_name}-${data.aws_region.current.name}-${var.env}"
  description = "Role permitting Lambda functions to be invoked from Lambda or Lambda@Edge"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaPolicy.json}"

  # If provision_lambdas is false, will get run 0 times
  count = "${var.provision_lambdas != "false" ? 1 : 0}"
}

# ---------------------------------------------------------------------------------------------------------------------
# BUILD POLICY DOCUMENT FROM TEMPLATE ALLOWING LAMBDAS TO WRITE TO CLOUDWATCH
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "log_policy_template" {
  template = "${file("${path.module}/logging_policy.json")}"

  vars {
    region = "${data.aws_region.current.name}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    headers_lambda_name = "${var.headers_lambda_name}"
    paths_lambda_name = "${var.paths_lambda_name}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE POLICY IN IAM WITH ABOVE DOCUMENT
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "log_policy" {
  name        = "${var.lambda_base_name_with_env}-log-pol"
  path        = "/"
  description = "Policy ${local.usable_chars_for_domain} permitting ${var.domain_name} lambdas to log to CloudWatch"

  policy = "${data.template_file.log_policy_template.rendered}"

  # If provision_lambdas is false, will get run 0 times
  count = "${var.provision_lambdas != "false" ? 1 : 0}"
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH THE ABOVE POLICY TO ROLE WE CREATED
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "logging-attach" {
  role       = "${aws_iam_role.main.0.name}"
  policy_arn = "${aws_iam_policy.log_policy.0.arn}"

  # If provision_lambdas is false, will get run 0 times
  count = "${var.provision_lambdas != "false" ? 1 : 0}"
}