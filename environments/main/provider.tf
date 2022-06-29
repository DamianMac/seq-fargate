terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10.0"
    }
  }

  backend "remote" {
    organization = "larene-dev"

    workspaces {
      name = ""
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}


