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

resource "aws_route53_zone" "internal_zone" {
  name = local.internal_zone
}

resource "aws_route53_record" "internal_delegation" {
  allow_overwrite = true
  name            = "internal"
  ttl             = 300
  type            = "NS"
  zone_id         = aws_route53_zone.parent_zone.id
  records         = aws_route53_zone.internal_zone.name_servers
}
