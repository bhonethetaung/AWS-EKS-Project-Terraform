variable "aws_region" {
  description = "aws region"
  type = string
}

variable "aws_profile" {
  description = "aws profile"
  type = string
}

variable "kube_config" {
  description = "kube config path"
  type = string
}

variable "lb_controller_name" {
  description = "load balancer controller name"
  type = string
}

variable "helm_repo" {
  description = "Helm Repo"
  type = string
}

variable "helm_chart" {
  description = "Helm chart"
  type = string
}

# variable "lb_controller_policy" {
#   description = "lb controller policy"
#   type = string
# }