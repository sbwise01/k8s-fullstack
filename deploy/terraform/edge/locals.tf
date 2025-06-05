locals {
  deployment_name       = "k8s-fullstack"
  region                = "us-east-1"
  parent_zone           = "aws.bradandmarsha.com"
  zone                  = "${local.deployment_name}.${local.parent_zone}"
  api                   = "api.${local.zone}"
  internal              = "internal.${local.zone}"
  ingress_lb_name       = "istio-ingressgateway"
  ingress_region        = "us-east-2"
  ingress_tls_protocols = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
}
