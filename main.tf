terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.86.1"
    }
  }
}

terraform {
 backend "s3" {
   bucket = "ccap-control-tower-terraform-state-bucket"
   key = "terraform.tfstate"
   region = "us-east-1"
 }
}

# Configure the AWS provider
provider "aws" {
  region = "${var.region}" # region = "us-east-2"
  profile = "${var.aws_profile}"
}



