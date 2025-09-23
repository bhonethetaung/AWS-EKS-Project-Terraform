data "terraform_remote_state" "vpc" {
    backend = "s3"
    config  = {
        bucket  = "terraform-state"
        key     = "vpc_state/terraform.tfstate"
        region  = "us-east-1"
        profile = "YOUR AWS PROFILE"
    }
}

data "terraform_remote_state" "eks" {
    backend = "s3"
    config  = {
        bucket  = "terraform-state"
        key     = "eks_state/terraform.tfstate"
        region  = "us-east-1"
        profile = "YOUR AWS PROFILE"
    }
}

data "terraform_remote_state" "iam" {
    backend = "s3"
    config  = {
        bucket  = "terraform-state"
        key     = "iam_state/terraform.tfstate"
        region  = "us-east-1"
        profile = "YOUR AWS PROFILE"
    }
}