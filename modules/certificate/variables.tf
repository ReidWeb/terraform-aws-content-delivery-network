# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------
variable "env" {
  description = "Deployment environment of application, will be included in resource names, and tags. e.g. 'dev'"
}

variable "domain_name" {
  description = "Primary domain for this distribution. Be aware that A & AAAA records will be created in Route53 for this with target of your CloudFront distribution. If not provided, no certificate will be created."
}

variable "profile" {
  description = "Profile to use - required because we have to do some fiddling with the provider object to create certs in the right region."
}

variable "shared_credentials_file" {
  description = "Shared credentials file to use - required because we have to do some fiddling with the provider object to create certs in the right region."
}

variable "region" {
  description = "Shared credentials file to use - required because we have to do some fiddling with the provider object to create certs in the right region."
  default     = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "additional_domains" {
  description = "Additional domains for this distribution. Be ware that A & AAAA records will be created in Route53 for this with a target of your CloudFront distrubution. If not provided, no additional domains will be added."
  type        = "list"
  default     = []
}
