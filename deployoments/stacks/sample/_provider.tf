terraform {
  backend "s3" {
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "default"
}
