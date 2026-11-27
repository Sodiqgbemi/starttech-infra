output "vpc_id" {
  value = module.networking.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "frontend_bucket_name" {
  value = module.storage.frontend_bucket_name
}

output "ecr_repository_url" {
  value = module.storage.ecr_repository_url
}

output "cloudfront_distribution_id" {
  value = module.cdn.distribution_id
}

output "cloudfront_domain_name" {
  value = module.cdn.distribution_domain_name
}

output "redis_host" {
  value = module.database.redis_host
}

output "redis_endpoint" {
  value = module.database.redis_endpoint
}

output "grader_access_key_id" {
  value     = aws_iam_access_key.grader.id
  sensitive = true
}

output "grader_secret_access_key" {
  value     = aws_iam_access_key.grader.secret
  sensitive = true
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider_url
}
