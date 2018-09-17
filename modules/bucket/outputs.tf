output "bucket_id" {
  value = "${aws_s3_bucket.private_bucket.id}"
  description = "ID for Origin S3 Bucket"
}
output "bucket_regional_domain_name" {
  value = "${aws_s3_bucket.private_bucket.bucket_regional_domain_name}"
  description = "Regional domain name for Origin S3 Bucket"
}