# S3 Bucket IAM Policy

This folder contains a [Terraform](https://www.terraform.io/) module that attaches a policy to a specified 'Origin' bucket permitting access from the specified CloudFront Distribution. 

Normally, you'd get this attachment by default if you're using the [content-delivery-network module](https://github.com/reidweb/terraform-aws-content-delivery-network/tree/master), 

You can use this module as follows

```hcl
module "bucket_iam_policy" {
  source = "git::git@github.com:reidweb/terraform-aws-content-delivery-network.git//modules/lambda-iam-policies"

  bucket_arn = "${module.bucket.bucket_arn}"
  bucket_id = "${module.bucket.bucket_id}"
  scloudfront_origin_iam_arn = "${module.cloudfront_distribution.cloudfront_origin_iam_arn}"
}
```
You can find the parameters in [variables.tf](variables.tf).