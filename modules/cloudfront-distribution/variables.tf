# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "cert_arn" {
  description = "ARN of certificate in ACM in us-east-1 created for this distribution"
}

variable "env" {
  description = "Deployment environment of application, will be included in resource names, and tags. e.g. 'dev'"
}

variable "provision_lambdas" {
  description = "Whether to provision lambdas"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL INPUTS
# ---------------------------------------------------------------------------------------------------------------------

variable "domain_name" {
  description = "Primary domain for this distribution."
  default = ""
}

variable "bucket_regional_domain_name" {
  description = "Website endpoint for S3 bucket to be used in origin"
  default = ""
}

variable "additional_domains" {
  description = "Additional domains for this distribution. Be ware that A & AAAA records will be created in Route53 for this with a target of your CloudFront distrubution. If not provided, no additional domains will be added."
  type = "list"
  default = []
}

variable "paths_lambda_qualified_arn" {
  description = "Qualified ARN for paths lambda"
  default = ""
}

variable "headers_lambda_qualified_arn" {
  description = "Qualified ARN for headers lambda"
  default = ""
}