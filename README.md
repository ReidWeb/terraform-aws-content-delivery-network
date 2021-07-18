# Content Delivery Network AWS Module

This repo contains a Module for deploying a Content Delivery Network (CDN) on [Amazon Web Services (AWS)](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/).

A content delivery network (CDN) is a system of distributed servers (network) that deliver pages and other Web content to a user, based on the geographic locations of the user, the origin of the webpage and the content delivery server.

This module can create your CDN in a manner compliant with best practices for frameworks such as [GatsbyJS](https://www.gatsbyjs.org/) where HTML files are not cached, [as per their recommendation](https://github.com/gatsbyjs/gatsby/blob/master/docs/docs/caching.md). This is done with a pair of [Lambda@Edge functions connected to the CloudFront distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html). Please note that at this time this functionality is only available in the AWS `us-east-1` region.

![CDN Architecture](https://github.com/ReidWeb/terraform-aws-content-delivery-network/blob/main/_docs/architecture.png?raw=true)

## Usage

This module can be used as follows

```hcl
module "content-delivery-network" {
  source  = "ReidWeb/content-delivery-network/aws"

  env = "dev"
  domain_name = "mysite.dev.aws.example.com"
  additional_domains = ["www.mysite.dev.aws.example.com", "blog.dev.aws.example.com"]
  route53_zone_name = "dev.aws.example.com"
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/yourUser/.aws/credentials"
  profile                 = "dev-profile"
  env                     = "Dev"
}
```

**Note that Lambda@Edge is currently only supported in us-east-1**

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
|`env` | Deployment environment of application, will be included in resource names, and tags | string | - | yes |
|`profile`| Profile to use - required because we have to do some fiddling with the provider object to create certs in the right region. | string | - | yes |
|`shared_credentials_file` | Shared credentials file to use - required because we have to do some fiddling with the provider object to create certs in the right region. | string | - | yes |
|`region` | Shared credentials file to use - required because we have to do some fiddling with the provider object to create certs in the right region. | string | `us-east-1` | no
|`domain_name` | Primary domain for this distribution. | string | `""` | no |
|`additional_domains` | Additional domains for this distribution. | list | `[]` | no |
|`route53_zone_name` | The name of your Route 53 zone in which to create the records | string |`""` | no |
|`provision_lambdas` |  Whether to provision the custom event Lambdas, or use a basic CloudFront distribution | string | `"true"` | no |

Be sure to read the [inputs](https://registry.terraform.io/modules/ReidWeb/content-delivery-network/aws?tab=inputs) documentation before use - as omission of certain parameters will lead to behaviour changing.

### Outputs

| Name | Description |
|------|-------------|
|`headers_lambda_qualified_arn`| Qualified ARN of headers Lambda |
|`paths_lambda_qualified_arn`| |
|`lambda_role_arn`| ARN of role assigned to Lambdas |
|`bucket_id`| ID for Origin S3 Bucket |
|`bucket_domain_name`| Domain name for Origin S3 Bucket |
|`certificate_id`| ID of certfificate provisioned in ACM |
|`certificate_arn`| ARN of certificate provisioned in ACM |
|`cloudfront_dist_id`| ID of CloudFront Distribution |
|`cloudfront_dist_zone_id`| Zone ID of CloudFront Distribution |
|`cloudfront_domain`| .cloudfront.net domain of Distribution |
|`cloudfront_origin_iam_arn`| CloudFront Origin Acess Identity |

## FAQ

### What's a module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such 
as a database or server cluster. Each Module is created using [Terraform](https://www.terraform.io/), and
includes automated tests, examples, and documentation. It is maintained both by the open source community and 
companies that provide commercial support. 

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse 
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, 
you can leverage the work of the Module community to pick up infrastructure improvements through
a version number bump.

### What code is included in this module:

* [lambda-iam-role](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/lambda-iam-policies): This module creates the necessary [IAM](https://aws.amazon.com/iam/) roles and policies for the Lambda functions to log to [CloudWatch](https://aws.amazon.com/cloudwatch/) and to be invoked as part of the [CloudFront](https://aws.amazon.com/cloudfront/) distribution's event sequence using [Lambda@Edge](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html).
* [lambdas](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/lambdas): This module provisions the [Lambda functions](https://aws.amazon.com/lambda/) for handling events from CloudFront via Lambda@Edge.
* [certificate](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/certificate): This module provisions a certificate for the domains specified by the user using [Amazon Certificate Manager (ACM)](https://aws.amazon.com/certificate-manager/).
* [bucket](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/bucket): This module provisions the [Amazon S3](https://aws.amazon.com/s3/) Bucket that will be used as the 'origin' for the CDN, along with the necessary policy that permits the CloudFront distribution to serve objects from it.
* [cloudfront-distribution](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/cloudfront-distribution): This module creates the [Amazon CloudFront](https://aws.amazon.com/cloudfront/) 'distribution' from which your resources will be accessed, using the user specified domains when provided.
* [bucket-iam-policy](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/bucket-iam-policy): This module creates the IAM policy that allows the CloudFront Origin to access the S3 bucket.
* [route53-records](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/route53-records): This module creates the [Amazon Route 53](https://aws.amazon.com/route53/) alias records for the domains specified targeting the CloudFront distribution.

### How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/CONTRIBUTING.md) for instructions.

### How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, 
along with the changelog, in the [Releases Page](../../releases). 

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a 
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, 
MINOR, and PATCH versions on each release to indicate any incompatibilities. 

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## License

This code is released under the MIT License. Please see [LICENSE](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/LICENSE) for more.

Copyright &copy; 2018 Peter Reid
