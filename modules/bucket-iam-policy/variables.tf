# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED INPUTS
# ---------------------------------------------------------------------------------------------------------------------


variable "bucket_arn" {
  description = "ARN of Origin S3 Bucket"
}

variable "bucket_id" {
  description = "ID of origin S3 bucket"
}

variable "cloudfront_origin_iam_arn" {
  description = "ARN of CloudFront Origin"
}