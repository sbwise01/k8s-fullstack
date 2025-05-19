provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Application = "poc"
      IaCTool     = "terraform"
      DeployedBy  = "brad"
      Name        = local.deployment_name
      Repository  = "github.com/sbwise01/${local.deployment_name}"
      Team        = "brad"
      Region      = local.region
      Environment = "poc"
    }
  }
}
