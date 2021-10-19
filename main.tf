terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    region  = "eu-central-1"
    profile = "default"
    key     = "tf_state"
    bucket  = "tfbucket6969"
  }
}

# terraform {
#   backend "local" {
#     path = "/home/pavel/terraformstate/tf_state"
#   }
# }

provider "aws" {
  profile = var.profile
  region  = var.region-default
  alias   = "provider"
}