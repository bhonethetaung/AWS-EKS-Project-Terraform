variable "aws_region" {
  description = "aws region"
  type = string
}

variable "aws_profile" {
  description = "aws profile"
  type = string
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "cidr" {
  description = "vpc cidr block"
}

variable "public_subnets" {
  description = "vpc's public subnet"
  type = list(string)
}

variable "private_subnets" {
  description = "vpc's private subnet"
  type = list(string)
}

variable "availability_zone" {
  description = "vpc availability zone"
  type = list(string)
}