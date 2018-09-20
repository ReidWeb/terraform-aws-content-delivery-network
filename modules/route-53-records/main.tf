locals {
  all_domains_uncompact = ["${var.domain_name}", "${var.additional_domains}"]
  all_domains           = "${compact(local.all_domains_uncompact)}"
}

data "aws_route53_zone" "zone" {
  provider = "aws.primary"

  name  = "${var.route53_zone_name}"
  count = "${length(var.route53_zone_name)}"
}

resource "aws_route53_record" "a" {
  provider = "aws.primary"

  zone_id = "${data.aws_route53_zone.zone.0.zone_id}"
  name    = "${element(var.additional_domains,count.index)}"
  type    = "A"

  alias {
    name                   = "${var.cloudfront_domain}"
    zone_id                = "${var.cloudfront_hosted_zone_id}"
    evaluate_target_health = false
  }

  count = "${length(local.all_domains)}"
}

resource "aws_route53_record" "aaaa" {
  provider = "aws.primary"

  zone_id = "${data.aws_route53_zone.zone.0.zone_id}"
  name    = "${element(local.all_domains,count.index)}"
  type    = "AAAA"

  alias {
    name                   = "${var.cloudfront_domain}"
    zone_id                = "${var.cloudfront_hosted_zone_id}"
    evaluate_target_health = false
  }

  count = "${length(local.all_domains)}"
}
