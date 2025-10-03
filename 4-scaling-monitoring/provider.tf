terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)
  token                  = data.terraform_remote_state.eks.outputs.cluster_auth.token
}

# provider "helm" {
#   kubernetes {
#     host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
#     cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)
#     token                  = data.terraform_remote_state.eks.outputs.cluster_auth.token
#   }
# }

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name,
        "--region", var.aws_region,
        "--profile", var.aws_profile
      ]
    }
  }
}