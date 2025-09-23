variable "aws_region" {
  description = "aws region"
  type = string
}

variable "aws_profile" {
  description = "aws profile"
  type = string
}

# variable "kube_config" {
#   description = "kube config path"
#   type = string
# }

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

variable "cluster_name" {
  description = "EKS cluster Name"
  type = string
}

variable "eks_version" {
  description = "EKS cluster version"
}

variable "enable_public_endpoint" {
  description = "EKS public access"
  type = bool
  default = true
}

variable "desired_size" {
  description = "Node group Desired Size"
  type = number
  default = 1
}

variable "max_size" {
  description = "Node group Maximum Size"
  type = number
  default = 1
}

variable "min_size" {
  description = "Node group Minimum Size"
  type = number
  default = 1
}

variable "instance_types" {
  description = "Node group instance type"
  type = list(string)
  default = ["t3.medium"]
}

variable "ami_types" {
  description = "Node group instance ami type"
  type = string
}

variable "disk_size" {
  description = "disk size"
  type = number
  default = 20
}