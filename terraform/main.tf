terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = local.azs
  cluster_name         = "starttech-cluster"
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "starttech-cluster"
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
  node_instance_type = var.node_instance_type
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
}

module "storage" {
  source = "./modules/storage"
}

module "database" {
  source = "./modules/database"

  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  eks_security_group_id = module.eks.cluster_primary_security_group_id
  vpc_cidr              = module.networking.vpc_cidr
}

module "cdn" {
  source = "./modules/cdn"

  s3_bucket_name                 = module.storage.frontend_bucket_name
  s3_bucket_arn                  = module.storage.frontend_bucket_arn
  s3_bucket_regional_domain_name = module.storage.frontend_bucket_regional_domain_name
  alb_dns_name                   = var.alb_dns_name
}

# Read-only grader IAM user required by the assessment
resource "aws_iam_user" "grader" {
  name = "start-tech-grader"
}

resource "aws_iam_user_policy" "grader_readonly" {
  name = "start-tech-grader-readonly"
  user = aws_iam_user.grader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "GraderReadOnlyS3"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketPublicAccessBlock",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Sid    = "GraderReadOnlyCloudFront"
        Effect = "Allow"
        Action = [
          "cloudfront:ListDistributions",
          "cloudfront:GetDistributionConfig"
        ]
        Resource = "*"
      },
      {
        Sid    = "GraderReadOnlyEKS"
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Sid    = "GraderReadOnlyElastiCache"
        Effect = "Allow"
        Action = [
          "elasticache:DescribeCacheClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "grader" {
  user = aws_iam_user.grader.name
}
