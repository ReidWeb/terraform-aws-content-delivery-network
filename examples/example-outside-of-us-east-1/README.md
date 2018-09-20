# Deployment outside of us-east-1 (N. Virginia)

This folder contains a terraform manifest for deploying your CDN outside of AWS' `us-east-1` region. 

## Quick Start

1. In this directory run `terraform init`
1. Edit the `main.tf` file to contain the details of your distribution
1. Run `terraform apply`
1. Review changes
1. Type `yes` to accept changes
1. Check your inbox for a certificate validation request(s) and accept
1. Wait for deployment to complete.
1. Upload files to the S3 bucket that should have been created with your specified `domain_name` as an identifier
1. Wait for your CloudFront distribution to complete deployment
1. Access the files on your `domain_name` URI.

## Notes

### Unavailable Features

Due to [restrictions on CloudFront triggers for Lambda Functions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-requirements-limits.html#lambda-requirements-cloudfront-triggers), selecting a region other than `us-east-1` for deployment will lead to the module selecting not to deploy any Lambda Functions.

### Restrictions

[AWS only supports `us-east-1` as the source for CloudFront distribution certificates created by ACM](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cnames-and-https-requirements.html#https-requirements-aws-region) as such the module will change region mid-deployment to `us-east-1` and create the certificate.

