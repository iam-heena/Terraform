terraform {
  backend "s3" {
    bucket = "demoheebabucket03"
    key = "terraform.tfstate"
    region = "us-east-1"

  }
}
