resource "aws_route53_zone" "parent_zone" {
  name              = local.parent_zone
  delegation_set_id = local.delegation_set_id
}

resource "aws_route53_zone" "zone" {
  name = local.zone
}

resource "aws_route53_record" "delegation" {
  allow_overwrite = true
  name            = local.deployment_name
  ttl             = 300
  type            = "NS"
  zone_id         = aws_route53_zone.parent_zone.id
  records         = aws_route53_zone.zone.name_servers
}

resource "aws_route53_record" "traffic_edge" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = local.zone
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.traffic_edge.domain_name
    zone_id                = aws_cloudfront_distribution.traffic_edge.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "traffic_edge_api" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = local.api
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.traffic_edge.domain_name
    zone_id                = aws_cloudfront_distribution.traffic_edge.hosted_zone_id
    evaluate_target_health = true
  }
}
