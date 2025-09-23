data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}



# --- IAM role for AWS LB Controller ---
resource "aws_iam_role" "aws_lb_controller" {
  name        = "eks-lb-controller-role"
  description = "IAM role for AWS Load Balancer Controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.terraform_remote_state.eks.outputs.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.terraform_remote_state.eks.outputs.oidc_issuer, "https://", "")}:aud" = "sts.amazonaws.com"
            "${replace(data.terraform_remote_state.eks.outputs.oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "aws_lb_controller" {
  policy_arn = data.terraform_remote_state.iam.outputs.lb_controller_policy_arn
  role       = aws_iam_role.aws_lb_controller.name
  depends_on = [aws_iam_role.aws_lb_controller]
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = var.lb_controller_name
  repository = var.helm_repo
  chart      = var.helm_chart
  namespace  = "kube-system"

  create_namespace = false

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.cluster.name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_lb_controller.arn
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc.outputs.vpc_id
  }
}