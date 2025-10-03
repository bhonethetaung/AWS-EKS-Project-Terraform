output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority" {
  value = try(aws_eks_cluster.cluster.certificate_authority[0].data, "")
}

output "oidc_issuer" {
  value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "cluster_auth" {
  value = data.aws_eks_cluster_auth.cluster_auth
  sensitive = true
}