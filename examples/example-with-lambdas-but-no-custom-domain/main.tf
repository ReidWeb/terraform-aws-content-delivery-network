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
}
