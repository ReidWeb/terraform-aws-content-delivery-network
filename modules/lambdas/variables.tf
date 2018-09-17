# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "env" {
  description = "Deployment environment of application, will be included in resource names, and tags. e.g. 'dev'"
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