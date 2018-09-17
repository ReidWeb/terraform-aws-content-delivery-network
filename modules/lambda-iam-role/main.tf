# Load in the AWS account info, so we can use the account ID in file templates
data "aws_caller_identity" "current" {}

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
  name = "${var.lambda_base_name_with_env}-${var.region}-lambdaRole"
  description = "Role permitting Lambda functions to be invoked from Lambda or Lambda@Edge"
  assume_role_policy = "${data.aws_iam_policy_document.lambdaPolicy.json}"
}

# ---------------------------------------------------------------------------------------------------------------------
# BUILD POLICY DOCUMENT FROM TEMPLATE ALLOWING LAMBDAS TO WRITE TO CLOUDWATCH
# ---------------------------------------------------------------------------------------------------------------------
data "template_file" "log_policy_template" {
  template = "${file("${path.module}/logging_policy.json")}"

  vars {
    region = "${var.region}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    headers_lamda_name = "${var.headers_lambda_name}"
    paths_lambda_name = "${var.paths_lambda_name}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE POLICY IN IAM WITH ABOVE DOCUMENT
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "log_policy" {
  name        = "${var.lambda_base_name_with_env}-log-pol"
  path        = "/"
  description = "Policy permitting ${var.domain_name} lambdas to log to CloudWatch"

  policy = "${data.template_file.log_policy_template.rendered}"
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH THE ABOVE POLICY TO ROLE WE CREATED
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "logging-attach" {
  role       = "${aws_iam_role.main.name}"
  policy_arn = "${aws_iam_policy.log_policy.arn}"
}

