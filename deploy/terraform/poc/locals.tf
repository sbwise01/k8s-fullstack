locals {
  deployment_name = "k8s-fullstack"
  region          = "us-east-2"
  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
}
