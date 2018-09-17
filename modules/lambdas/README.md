# Lambdas

This folder contains a [Terraform](https://www.terraform.io/) module that creates the Lambda functions. 

Normally, you'd get this Role by default if you're using the [content-delivery-network module](https://github.com/reidweb/terraform-aws-content-delivery-network/tree/master), 

## Usage

You can use this module as follows

```hcl
module "iam_roles" {
  source = "git::git@github.com:reidweb/terraform-aws-content-delivery-network.git//modules/lambdas"

  region = "us-east-1"
  domain_name = "foo.example.com"
  env = "dev"
}
```
You can find the parameters in [variables.tf](variables.tf).