data "aws_caller_identity" "current" {}

data "aws_route53_zone" "zone" {
  name = local.zone
}

data "aws_lb" "internal_ingress_lb" {
  provider = aws.ingress-region

  name = local.ingress_lb_name
}
