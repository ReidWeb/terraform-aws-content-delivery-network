provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/yourUser/.aws/credentials"
  profile                 = "dev-profile"
}

module "main" {
  source = "ReidWeb/content-delivery-network/aws"

  shared_credentials_file = "/Users/yourUser/.aws/credentials"
  profile                 = "dev-profile"
  env                     = "Dev"
  domain_name             = "cdn.example.com"
  additional_domains      = ["foo.example.com", "bar.example.com"]
  route53_zone_name       = "dev.aws.reidweb.com"
  provision_lambdas       = "false"
}
