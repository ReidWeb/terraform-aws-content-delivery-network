# Deployment with a custom domain, and no Lambda functions

This folder contains a terraform manifest for deploying your CDN in `us-east-1` with Lamdba@Edge functions disabled, and custom domains attached.

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


