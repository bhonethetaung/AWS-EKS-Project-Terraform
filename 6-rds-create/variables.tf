variable "aws_region" {
  description = "aws region"
  type = string
}

variable "aws_profile" {
  description = "aws profile"
  type = string
}

variable "rds_cluster_name" {
  description = "RDS Cluster Name"
  type = string
}

variable "rds_engine" {
  description = "RDS Engine Name"
  type = string
}

variable "cluster_engine_mode" {
  description = "RDS cluster engine mode"
  type = string
}

variable "rds_username" {
  description = "RDS master username"
  type = string
}

variable "rds_password" {
  description = "RDS master password"
  type = string
}

variable "db_name" {
  description = "RDS Default DB name"
  type = string
}

variable "rds_instance_type" {
  description = "RDS instane type"
  type = string
}