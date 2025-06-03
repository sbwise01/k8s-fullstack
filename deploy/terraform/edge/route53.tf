resource "aws_route53_record" "traffic_edge" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.zone
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.traffic_edge.domain_name
    zone_id                = aws_cloudfront_distribution.traffic_edge.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "traffic_edge_api" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.api
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.traffic_edge.domain_name
    zone_id                = aws_cloudfront_distribution.traffic_edge.hosted_zone_id
    evaluate_target_health = true
  }
}
