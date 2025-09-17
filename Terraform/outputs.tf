output "cluster_id" {
  value = aws_eks_cluster.vedant.id
}

output "cluster_name" {
  value = aws_eks_cluster.vedant.name
}

output "node_group_id" {
  value = aws_eks_node_group.vedant.id
}

output "vpc_id" {
  value = aws_vpc.vedant_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.vedant_subnet[*].id
}
