terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0" # AWS provider version, not terraform version
    }
  }

  backend "s3" {
    bucket = "kalri-test-bucket"
    key    = "eksctl"
    region = "us-east-1"
    dynamodb_table = "kalari-test-table"
  }
}

provider "aws" {
  region = "us-east-1"
}