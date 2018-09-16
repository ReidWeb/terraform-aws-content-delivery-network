variable "env"                { }
variable "domain_name" {}

module "bucket" {
  source = "./bucket"

  domain_name = "${var.domain_name}"
  env = "${var.env}"
}

output "bucket_regional_domain" { value = "${module.bucket.bucket_regional_domain_name}" }
output "bucket_id" { value = "${module.bucket.bucket_id}" }