terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
  }
  required_version = ">=1.2.4"
}

provider "aws" {
  region = "eu-west-1"
}