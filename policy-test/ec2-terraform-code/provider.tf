terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.20.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# configuring docker and aws as providers
provider "docker" {}

provider "aws" {
  region  = "us-west-1"
  profile = "fyka"
}



