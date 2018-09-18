# In order to pass out the bucket ID we must combine the results of both bucket resources, and extract the 0th element

output "bucket_id" {
  value = "${element(concat(aws_s3_bucket.bucket_with_www.*.id, aws_s3_bucket.bucket_without_www.*.id),0)}"
  description = "ID for Origin S3 Bucket"
}
output "bucket_regional_domain_name" {
  value = "${element(concat(aws_s3_bucket.bucket_with_www.*.bucket_regional_domain_name, list("")),0)}"
  description = "Regional domain name for Origin S3 Bucket"
}