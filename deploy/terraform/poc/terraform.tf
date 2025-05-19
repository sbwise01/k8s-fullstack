terraform {
  required_version = "~> 1.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.98"
    }
  }

  backend "s3" {
    bucket = "brad-tf-state"
    key    = "k8s-fullstack.tfstate"
    region = "us-east-2"
  }
}
