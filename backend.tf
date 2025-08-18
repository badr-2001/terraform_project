terraform {
  backend "s3" {
    bucket         = "bei22-bucket"
    key            = "part1.step3/terraform.tfstate"
    region         = "eu-west-1"
  }
}