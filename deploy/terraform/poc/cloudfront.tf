resource "aws_cloudfront_distribution" "traffic_edge" {
  provider = aws.edge-region

  origin {
    domain_name = local.internal
    origin_id   = "internalEKSIngess"

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  aliases = [
    local.zone,
    local.api
  ]

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "internalEKSIngess"
    cache_policy_id          = aws_cloudfront_cache_policy.traffic_edge_host_origin.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.traffic_edge_host_origin.id
    viewer_protocol_policy   = "redirect-to-https"
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
