# Lambda IAM Role
This folder contains a [Terraform](https://www.terraform.io/) module that defines the IAM Role and associated policies used by Lambda@Edge functions. 

Normally, you'd get this Role by default if you're using the [lambdas submodule](https://github.com/reidweb/terraform-aws-content-delivery-network/tree/master/modules/lambdas), 

You can use this module as follows

```hcl
module "iam_roles" {
  source = "git::git@github.com:reidweb/terraform-aws-content-delivery-network.git//modules/lambda-iam-policies"

  region = "${var.region}"
    lambda_base_name_with_env = "dev"
    paths_lambda_name = "myPathsLambda"
    headers_lambda_name = "myHeadersLambda"
}
```
You can find the parameters in [variables.tf](variables.tf).