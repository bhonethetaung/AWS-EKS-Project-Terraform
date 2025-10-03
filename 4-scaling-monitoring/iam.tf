locals {
  ca_sa_name   = "cluster-autoscaler"
  ca_namespace = "kube-system"
  sa_subject   = "system:serviceaccount:${local.ca_namespace}:${local.ca_sa_name}"
}

resource "aws_iam_role" "cluster_autoscaler" {
  name = "eks-cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = data.terraform_remote_state.eks.outputs.oidc_provider_arn
        # aws_iam_openid_connect_provider.eks_oidc.arn
      }
      Condition = {
        "StringEquals" = {
          "${replace(data.terraform_remote_state.eks.outputs.oidc_issuer, "https://", "")}:sub" = local.sa_subject
        }
      }
    }]
  })
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "eks-cluster-autoscaler-policy"
  policy = file("${path.module}/policies/cluster-autoscaler-policy.json")
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}