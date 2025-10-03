variable "aws_region" {
  description = "aws region"
  type = string
}

variable "aws_profile" {
  description = "aws profile"
  type = string
}

variable "helm_chart_metrics" {
  description = "helm chart for metrics server"
  type = string
}

variable "helm_chart_autoscaler" {
  description = "helm chart for cluster autoscaler"
  type = string
}

variable "helm_repo_metrics" {
  description = "helm repo for metrics server"
  type = string
}

variable "helm_repo_autoscaler" {
  description = "helm repo for cluster autoscaler"
  type = string
}

variable "metrics_version" {
  description = "metrics server version"
  type = string
}

variable "autoscaler_version" {
  description = "autoscaler version"
  type = string
}