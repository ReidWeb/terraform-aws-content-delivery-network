# S3 Bucket 

This folder contains a [Terraform](https://www.terraform.io/) module that creates a S3 Bucket.

Normally, you'd get this Bucket by default if you're using the [content-delivery-network module](https://github.com/reidweb/terraform-aws-content-delivery-network/tree/master), 

## Usage

You can use this module as follows

```hcl
module "iam_roles" {
  source = "git::git@github.com:reidweb/terraform-aws-content-delivery-network.git//modules/bucket"

  domain_name = "foo.example.com"
  env = "dev"
}
```
You can find the parameters in [variables.tf](variables.tf).