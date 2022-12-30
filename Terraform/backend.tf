terraform {
  backend "s3" {
    bucket = "rssr-tf-state"
    key = "jenkins/ansible"
    region = "ap-south-1"
  }
}  
