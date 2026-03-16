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
resource "aws_s3_bucket" "terraform-bucket" {
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

# Create App Runner role
resource "aws_iam_role" "apprunner_role" {
  name = "apprunner-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_policy" {
  role       = aws_iam_role.apprunner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# Create App Runner service
resource "aws_apprunner_service" "go_app_service" {
  service_name = "go-app-service"

  source_configuration {
    image_repository {
      image_identifier      = "${aws_ecr_repository.app_repo.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = "8080"
      }
    }
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }
    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "0.5 GB"
  }
}

# Output App Runner URL
output "app_url" {
  value = "https://${aws_apprunner_service.go_app_service.service_url}"
}
