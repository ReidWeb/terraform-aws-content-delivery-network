locals {
  all_domains = ["${var.domain_name}","${var.additional_domains}"]
}

data "aws_route53_zone" "zone" {
  name = "${var.route53_zone_name}"
}


resource "aws_route53_record" "a" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${element(var.additional_domains,count.index)}"
  type    = "A"

  alias {
    name = "${var.cloudfront_domain}"
    zone_id = "${var.cloudfront_hosted_zone_id}"
    evaluate_target_health = false
  }

  count      = "${length(var.additional_domains)}"
}

resource "aws_route53_record" "aaaa" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${element(local.all_domains,count.index)}"
  type    = "AAAA"

  alias {
    name = "${var.cloudfront_domain}"
    zone_id = "${var.cloudfront_hosted_zone_id}"
    evaluate_target_health = false
  }

  count      = "${length(local.all_domains)}"
}