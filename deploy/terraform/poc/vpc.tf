module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${local.deployment_name}-main"

  cidr            = "10.11.0.0/16"
  azs             = local.azs
  private_subnets = ["10.11.0.0/24", "10.11.1.0/24", "10.11.2.0/24"]
  public_subnets  = ["10.11.3.0/24", "10.11.4.0/24", "10.11.5.0/24"]

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.deployment_name}" = "shared"
    "kubernetes.io/role/elb"                         = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.deployment_name}" = "shared"
    "kubernetes.io/role/internal-elb"                = "1"
  }

  enable_nat_gateway = true
}
