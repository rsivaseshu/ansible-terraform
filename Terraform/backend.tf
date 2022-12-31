terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "rssr-tf-state"
    key = "jenkins/ansible"
    region = "ap-south-1"
  }
}  
