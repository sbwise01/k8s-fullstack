locals {
  deployment_name = "k8s-fullstack"
  region          = "us-east-2"
  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]

  parent_zone       = "aws.bradandmarsha.com"
  delegation_set_id = "N01520513SWFAR055EX7G"
  zone              = "${local.deployment_name}.${local.parent_zone}"
}
