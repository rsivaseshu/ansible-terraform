terraform {
  backend "s3" {
    bucket = "rssr-tf-backend-bucket"
    key = "jenkins/infra"
    region = "ap-south-1"
  }
}  
