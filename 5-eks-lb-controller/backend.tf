terraform {
  backend "s3" {
    bucket          = "terraform-state"
    key             = "lb_controller_state/terraform.tfstate"
    dynamodb_table  = "terraform-locks"
    region          = "us-east-1"
    profile         = "YOUR AWS PROFILE"
    encrypt         = true
  }
}