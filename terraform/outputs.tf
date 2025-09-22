# Define outputs for cluster info, VPC, etc.

# Output the cluster name
output "cluster_name" {
  value       = aws_eks_cluster.main.name
  description = "The name of the EKS cluster."
}

# Output the VPC ID
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

# Output the subnet IDs
output "subnet_ids" {
  value       = aws_subnet.main[*].id
  description = "The IDs of the subnets."
}
