# Define variables for EKS, VPC, IAM, etc.

# Variable for the cluster name
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "zpc"
}

# Variable for the VPC CIDR block
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# Variable for the number of subnets
variable "subnet_count" {
  description = "The number of subnets to create."
  type        = number
  default     = 2
}
variable "region" {
  default = "ap-south-1"
}

