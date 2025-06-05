resource "aws_cloudfront_distribution" "traffic_edge" {
  origin {
    domain_name = local.internal
    origin_id   = "internalEKSIngess"

    vpc_origin_config {
      origin_keepalive_timeout = "5"
      origin_read_timeout      = "30"
      vpc_origin_id            = aws_cloudfront_vpc_origin.internal_origin.id
    }
  }

  aliases = [
    local.zone,
    local.api
  ]
  enabled    = true
  web_acl_id = aws_wafv2_web_acl.traffic_edge.arn

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "internalEKSIngess"
    cache_policy_id          = aws_cloudfront_cache_policy.traffic_edge_host_origin.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.traffic_edge_host_origin.id
    viewer_protocol_policy   = "redirect-to-https"

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.bot_control_origin_request_edge.qualified_arn
      include_body = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_cloudfront_cache_policy" "traffic_edge_host_origin" {
  name        = "traffic-edge-host-origin"
  comment     = "Policy to forward host header to origin"
  default_ttl = 3600
  max_ttl     = 86400
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host"]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "traffic_edge_host_origin" {
  name    = "traffic-edge-host-origin"
  comment = "Policy to forward host header to origin"
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Host"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_vpc_origin" "internal_origin" {
  vpc_origin_endpoint_config {
    name                   = "internal-origin"
    arn                    = data.aws_lb.internal_ingress_lb.arn
    http_port              = "80"
    https_port             = "443"
    origin_protocol_policy = "https-only"

    origin_ssl_protocols {
      items    = local.ingress_tls_protocols
      quantity = length(local.ingress_tls_protocols)
    }
  }
}
