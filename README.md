# Content Delivery Network AWS Module

This repo contains a Module for deploying a Content Delivery Network (CDN) on [Amazon Web Services (AWS)](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/).

A content delivery network (CDN) is a system of distributed servers (network) that deliver pages and other Web content to a user, based on the geographic locations of the user, the origin of the webpage and the content delivery server.

This module can create your CDN in a manner compliant with best practices for frameworks such as [GatsbyJS](https://www.gatsbyjs.org/) where HTML files are not cached, [as per their recommendation](https://github.com/gatsbyjs/gatsby/blob/master/docs/docs/caching.md). This is done with a pair of [Lambda@Edge functions connected to the CloudFront distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html). Please note that at this time this functionality is only available in the AWS `us-east-1` region.

![CDN Architecture](https://github.com/ReidWeb/terraform-aws-content-delivery-network/blob/master/_docs/arch.png?raw=true)

## What's a module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such 
as a database or server cluster. Each Module is created using [Terraform](https://www.terraform.io/), and
includes automated tests, examples, and documentation. It is maintained both by the open source community and 
companies that provide commercial support. 

Instead of figuring out the details of how to run a piece of infrastructure from scratch, you can reuse 
existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, 
you can leverage the work of the Module community to pick up infrastructure improvements through
a version number bump.

## Code included in this module:

* [lambda-iam-policies](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/lambda-iam-policies): This module creates the necessary [IAM](https://aws.amazon.com/iam/) roles and policies for the Lambda functions to log to [CloudWatch](https://aws.amazon.com/cloudwatch/) and to be invoked as part of the [CloudFront](https://aws.amazon.com/cloudfront/) distribution's event sequence using [Lambda@Edge](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html).
* [lambdas](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/lambdas): This module provisions the [Lambda functions](https://aws.amazon.com/lambda/) for handling events from CloudFront via Lambda@Edge.
* [certificate](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/certificate): This module provisions a certificate for the domains specified by the user using [Amazon Certificate Manager (ACM)](https://aws.amazon.com/certificate-manager/).
* [bucket](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/bucket): This module provisions the [Amazon S3](https://aws.amazon.com/s3/) Bucket that will be used as the 'origin' for the CDN, along with the necessary policy that permits the CloudFront distribution to serve objects from it.
* [cloudfront-distribution](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/cloudfront-distribution): This module creates the [Amazon CloudFront](https://aws.amazon.com/cloudfront/) 'distribution' from which your resources will be accessed, using the user specified domains when provided.
* [route53-records](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/modules/route53-records): This module creates the [Amazon Route 53](https://aws.amazon.com/route53/) alias records for the domains specified targeting the CloudFront distribution.

# How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/CONTRIBUTING.md) for instructions.

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release, 
along with the changelog, in the [Releases Page](../../releases). 

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a 
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, 
MINOR, and PATCH versions on each release to indicate any incompatibilities. 

## License

This code is released under the MIT License. Please see [LICENSE](https://github.com/ReidWeb/terraform-aws-content-delivery-network/tree/master/LICENSE) for more.

Copyright &copy; 2018 Peter Reid