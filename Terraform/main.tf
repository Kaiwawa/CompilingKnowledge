terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.87.0"
    }
  }
    backend "s3" {
    bucket = "descomplicando-terraform-rbaumann"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" { 
  region = "us-east-1"
}
provider "aws" { 
  alias = "east"
  region = "us-east-1"
}