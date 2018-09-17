variable "env" {}
variable "domain_name" {}
variable "region" {}

module "lambdas" {
  source = "lambdas"

  domain_name = "${var.domain_name}"
  region = "${var.region}"
  env = "${var.env}"
}

output "headers_lambda_name" {
  value = "${module.lambdas.headers_lambda_name}"
}

output "paths_lambda_name" {
  value = "${module.lambdas.paths_lambda_name}"
}