# ---------------------------------------------------------------------------------------------------------------------
# CREATE TEMPLATE FILE WITH DATA PROVIDED
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/bucket_policy.json")}"

  vars {
    bucket_arn = "${var.bucket_arn}"
    iam_arn= "${var.cloudfront_origin_iam_arn}"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# APPLY POLICY (AS INLINE POLICY) TO EXISTING S3 BUCKET
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_id}"
  policy = "${data.template_file.bucket_policy.rendered}"
}
