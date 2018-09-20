provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "/Users/yourUser/.aws/credentials"
  profile                 = "dev-profile"
}

module "main" {
  source = "ReidWeb/content-delivery-network/aws"

  region                  = "eu-west-1"
  shared_credentials_file = "/Users/yourUser/.aws/credentials"
  profile                 = "dev-profile"
  env                     = "Dev"
  provision_lambdas       = "false"
}
