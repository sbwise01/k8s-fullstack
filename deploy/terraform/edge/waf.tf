resource "aws_wafv2_web_acl" "traffic_edge" {
  name        = "traffic-edge-rules"
  description = "Rules to apply to edge of traffic"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "bot-matching"
    priority = 1

    action {
      count {
        custom_request_handling {
          insert_header {
            name  = "bot-control"
            value = "bot"
          }
        }
      }
    }

    statement {
      regex_match_statement {
        regex_string = "^curl.*$"
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }


    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAF_BOT_ACL"
      sampled_requests_enabled   = false
    }
  }

  token_domains = [
    local.zone,
    local.api
  ]

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF_BOT_ACL"
    sampled_requests_enabled   = false
  }
}
