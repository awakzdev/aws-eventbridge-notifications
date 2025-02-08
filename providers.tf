terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.85.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Region has to be set to us-east-1 in order to see IAM User creation which doesn't show on other regions.
  default_tags {
    tags = {
      Environment = "banana"
      Terraform   = "True"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
