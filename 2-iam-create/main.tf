resource "aws_iam_role" "eks_cluster_role" {
  name               = "eks-cluster-role-${var.iam_name}"
  description        = "managed by terraform"
  assume_role_policy = file("${path.module}/policies/eks-cluster-trust.json")
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name               = "eks-node-role-${var.iam_name}"
  description        = "managed by terraform"
  assume_role_policy = file("${path.module}/policies/eks-node-trust.json")
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "eks_node_instance_profile" {
  name = "eks-node-instance-profile-${var.iam_name}"
  role = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role" "rds_monitor_role" {
  name               = "rds-monitor-role-${var.iam_name}"
  description        = "managed by terraform"
  assume_role_policy = file("${path.module}/policies/rds-monitoring-trust.json")
}

resource "aws_iam_role_policy_attachment" "rds_monitor_policy_attach" {
  role       = aws_iam_role.rds_monitor_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_iam_policy" "lb_controller_policy" {
  name        = "lb-controller-IAM"
  description = "Custom policy for loadbalancer controller"
  policy      = file("${path.module}/policies/LoadBalancerControllerIAM.json")
}