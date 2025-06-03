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
      Workspace   = "edge"
    }
  }
}

provider "aws" {
  alias  = "ingress-region"
  region = local.ingress_region

  default_tags {
    tags = {
      Application = "poc"
      IaCTool     = "terraform"
      DeployedBy  = "brad"
      Name        = local.deployment_name
      Repository  = "github.com/sbwise01/${local.deployment_name}"
      Team        = "brad"
      Region      = local.ingress_region
      Environment = "poc"
      Workspace   = "edge"
    }
  }
}
