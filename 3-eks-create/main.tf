resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = data.terraform_remote_state.iam.outputs.eks_cluster_role_arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = data.terraform_remote_state.vpc.outputs.private_subnets
    endpoint_public_access  = var.enable_public_endpoint
    endpoint_private_access = true
  }

  depends_on = [
    data.terraform_remote_state.iam
  ]
}

##################### Node Group #############################

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "Private-Node-group-${var.cluster_name}"
  node_role_arn   = data.terraform_remote_state.iam.outputs.eks_node_role_arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = var.instance_types
  ami_type       = var.ami_types
  disk_size      = var.disk_size
  capacity_type  = "ON_DEMAND"

  update_config {
    max_unavailable = 1
  }
}

# OIDC Provider for service accounts
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  
  client_id_list = ["sts.amazonaws.com"]
  
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.cluster.name
}