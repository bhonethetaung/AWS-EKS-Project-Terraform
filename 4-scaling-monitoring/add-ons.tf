resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = var.helm_repo_metrics
  chart      = var.helm_chart_metrics
  version    = "3.12.1" # lock to a stable version

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = var.helm_repo_autoscaler
  chart      = var.helm_chart_autoscaler
  version    = var.autoscaler_version

  set {
    name  = "autoDiscovery.clusterName"
    value = data.terraform_remote_state.eks.outputs.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  # Ensure CA only runs on one pod
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler.arn
  }
}