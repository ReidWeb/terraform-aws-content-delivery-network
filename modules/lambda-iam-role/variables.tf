# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "lambda_base_name_with_env" {
  description = "Name for both lambda functions as a collection"
}

variable "headers_lambda_name" {
  description = "Name for headers lambda"
}

variable "paths_lambda_name" {
  description = "Name for paths lambda"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "domain_name" {
  description = "Primary domain for this distribution."
  default = "cf-dist"
}

variable "provision_lambdas" {
  description = "Whether to provision lambdas"
  default = "true"
}