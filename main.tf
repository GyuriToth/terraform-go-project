# Set up AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Set up AWS provider region
provider "aws" {
  region = "eu-central-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "elso_bucketem" {
  bucket = "gyuri-terraform-bucket-2026" 

  tags = {
    Name        = "My terraform bucket"
    Environment = "Dev"
  }
}

resource "aws_ecr_repository" "app_repo" {
  name                 = "go-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app_repo.repository_url
}