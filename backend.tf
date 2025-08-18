terraform {
  backend "s3" {
    bucket         = "bei22-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
  }
}