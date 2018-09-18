# Certificate
This folder contains a [Terraform](https://www.terraform.io/) module that creates a certificate using Amazon Certificate Manager for the specified domains 

Normally, you'd get this Role by default if you're using the [content-delivery-network module](https://github.com/reidweb/terraform-aws-content-delivery-network/tree/master), 

**Please be aware that application of this module will submit a/multiple domain validation request(s) to the administrator of the specified domain(s) which will need to be approved before this module can progress.** 

You can use this module as follows

```hcl
module "iam_roles" {
  source = "git::git@github.com:reidweb/terraform-aws-content-delivery-network.git//modules/lambda-iam-policies"

  domain_name = "foo.example.com"
  env = "dev"
  additional_domains = ["foo1.example.com", "foo2.example.com"]
}
```
You can find the parameters in [variables.tf](variables.tf).