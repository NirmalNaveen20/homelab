terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.2.0"
    }
  }
  backend "s3" {
    bucket       = "teraform-state-s3"
    key          = "teraform-state-s3/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
  required_version = "~>1.11.0"
}

provider "aws" {
  region = "us-east-1"
}