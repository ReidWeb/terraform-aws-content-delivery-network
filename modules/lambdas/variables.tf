# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "env" {
  description = "Deployment environment of application, will be included in resource names, and tags. e.g. 'dev'"
}

variable "domain_name" {
  description = "Primary domain for this distribution."
}
