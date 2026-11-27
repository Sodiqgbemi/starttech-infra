output "cluster_name" {
  value = aws_eks_cluster.starttech-cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.starttech-cluster.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.starttech-cluster.certificate_authority[0].data
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster.id
}

output "cluster_primary_security_group_id" {
  value = aws_eks_cluster.starttech-cluster.vpc_config[0].cluster_security_group_id
}

output "node_group_name" {
  value = aws_eks_node_group.starttech-node-group.node_group_name
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.eks.url
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}
