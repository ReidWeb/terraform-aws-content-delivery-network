# CloudFront Distribution

This folder contains a [Terraform](https://www.terraform.io/) module that creates a CloudFront Distribution.

Normally, you'd get this CloudFront Distribution by default if you're using the [content-delivery-network module](https://github.com/reidweb/terraform-aws-content-delivery-network/tree/master), 

## Usage

You can use this module as follows

```hcl
module "iam_roles" {
  source = "git::git@github.com:reidweb/terraform-aws-content-delivery-network.git//modules/cloudfront-distribution"

  domain_name = "foo.example.com"
  bucket_regional_domain_name = "${module.bucket.bucket_regional_domain_name}"
  env = "dev"
  additional_domains = ["foo1.example.com", "foo2.example.com"]
  cert_arn = "${module.certificate.cert_arn}"
  headers_lambda_qualified_arn = "${module.lambdas.headers_lambda_qualified_arn}"
  paths_lambda_qualified_arn = "${module.lambdas.paths_lambda_qualified_arn}"
  provision_lambdas = "true"
}
```
You can find the parameters in [variables.tf](variables.tf).