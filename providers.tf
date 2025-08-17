provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "bei2-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
  }
}