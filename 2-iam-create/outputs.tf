output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_node_instance_profile_name" {
  value = aws_iam_instance_profile.eks_node_instance_profile.name
}

output "rds_monitor_role_arn" {
  value = aws_iam_role.rds_monitor_role.arn
}

output "lb_controller_policy_arn" {
  value = aws_iam_policy.lb_controller_policy.arn
}