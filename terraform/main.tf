#############################
# Providers
#############################
provider "aws" {
  region = "ap-south-1"
}

# Authenticate Kubernetes provider using EKS details
data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}

#############################
# Networking (VPC + Subnets)
#############################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "main" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "main-subnet-${count.index}"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }
}

#############################
# IAM Role for EKS
#############################
resource "aws_iam_role" "eks_role" {
  name = "eks-role-${var.cluster_name}" # avoid duplicate name errors
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "eks-role-${var.cluster_name}"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [name, tags]
  }
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#############################
# EKS Cluster
#############################
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = aws_subnet.main[*].id
  }
  tags = {
    Name = var.cluster_name
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [tags]
  }
}

#############################
# Kubernetes Namespaces
#############################
resource "kubernetes_namespace" "api" {
  metadata { name = "api" }
  lifecycle { ignore_changes = [metadata[0].name] }
}

resource "kubernetes_namespace" "auth" {
  metadata { name = "auth" }
  lifecycle { ignore_changes = [metadata[0].name] }
}

resource "kubernetes_namespace" "post" {
  metadata { n
