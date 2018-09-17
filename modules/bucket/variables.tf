# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "env" {
  description = "Deployment environment of application, will be included in tags"
}

variable "domain_name" {
  description = "Primary domain for this distribution."
  default = ""
}