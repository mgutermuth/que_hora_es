terraform {
  required_version = "0.12.29"
  required_providers {
    aws = "3.0.0"
  }
}


provider "aws" {
  region = "us-east-2"
}
