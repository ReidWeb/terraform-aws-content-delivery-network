# Content Delivery Network AWS Module

This repo contains a Module for deploying a Content Delivery Network (CDN) on [Amazon Web Services (AWS)](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/).

A content delivery network (CDN) is a system of distributed servers (network) that deliver pages and other Web content to a user, based on the geographic locations of the user, the origin of the webpage and the content delivery server.

This module can create your CDN in a manner compliant with best practices for frameworks such as [GatsbyJS](https://www.gatsbyjs.org/) where HTML files are not cached, [as per their recommendation](https://github.com/gatsbyjs/gatsby/blob/master/docs/docs/caching.md). This is done with a pair of [Lambda@Edge functions connected to the CloudFront distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html). Please note that at this time this functionality is only available in the AWS `us-east-1` region.

![CDN Architecture](https://github.com/ReidWeb/terraform-aws-content-delivery-network/blob/master/_docs/cdn-architecture.png?raw=true)