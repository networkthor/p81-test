variable "vpc_cidr" {}
variable "project_name" {}
variable "region" {}
variable "public_subnets" {
    type = list(any)
}
variable "private_subnets" {
    type = list(any)
}