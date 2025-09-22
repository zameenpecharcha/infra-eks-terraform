# Inline configuration for VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  count = var.subnet_count
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "main-subnet-${count.index}"
  }
}

# Declare the missing data resource for availability zones
data "aws_availability_zones" "available" {}

# Inline configuration for IAM
resource "aws_iam_role" "eks_role" {
  name = "eks-role"
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
    Name = "eks-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Inline configuration for EKS
resource "aws_eks_cluster" "main" {
  name = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = aws_subnet.main[*].id
  }
  tags = {
    Name = var.cluster_name
  }
}

# Define Kubernetes namespaces for all services
resource "kubernetes_namespace" "api" {
  metadata {
    name = "api"
  }
}

resource "kubernetes_namespace" "auth" {
  metadata {
    name = "auth"
  }
}

resource "kubernetes_namespace" "post" {
  metadata {
    name = "post"
  }
}

# Example: Create namespaces for microservices
resource "kubernetes_namespace" "property" {
  metadata {
    name = "property"
  }
}

resource "kubernetes_namespace" "user" {
  metadata {
    name = "user"
  }
}

resource "kubernetes_namespace" "chat" {
  metadata {
    name = "chat"
  }
}

# Define Kubernetes services for all microservices
resource "kubernetes_service" "api_gateway" {
  metadata {
    name      = "api-gateway"
    namespace = kubernetes_namespace.api.metadata[0].name
  }
  spec {
    selector = {
      app = "api-gateway"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "auth_service" {
  metadata {
    name      = "auth-service"
    namespace = kubernetes_namespace.auth.metadata[0].name
  }
  spec {
    selector = {
      app = "auth-service"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5001
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "post_service" {
  metadata {
    name      = "post-service"
    namespace = kubernetes_namespace.post.metadata[0].name
  }
  spec {
    selector = {
      app = "post-service"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5002
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "property_service" {
  metadata {
    name      = "property-service"
    namespace = kubernetes_namespace.property.metadata[0].name
  }
  spec {
    selector = {
      app = "property-service"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5003
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "chat_service" {
  metadata {
    name      = "chat-service"
    namespace = kubernetes_namespace.chat.metadata[0].name
  }
  spec {
    selector = {
      app = "chat-service"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5004
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_service" "user_service" {
  metadata {
    name      = "user-service"
    namespace = kubernetes_namespace.user.metadata[0].name
  }
  spec {
    selector = {
      app = "user-service"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5005
    }
    type = "ClusterIP"
  }
}

# Kubernetes provider configuration
provider "kubernetes" {
  config_path = "~/.kube/config" # Update this path if your kubeconfig is located elsewhere
}

provider "aws" {
  region = "us-east-1"
}
