resource "aws_eks_cluster" "vedant" {
  name     = "vedant-cluster"
  role_arn = aws_iam_role.vedant_cluster_role.arn

  vpc_config {
    subnet_ids         = aws_subnet.vedant_subnet[*].id
    security_group_ids = [aws_security_group.vedant_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.vedant_cluster_role_policy
  ]
}

resource "aws_eks_node_group" "vedant" {
  cluster_name    = aws_eks_cluster.vedant.name
  node_group_name = "vedant-node-group"
  node_role_arn   = aws_iam_role.vedant_node_group_role.arn
  subnet_ids      = aws_subnet.vedant_subnet[*].id

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = var.instance_types

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.vedant_node_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.vedant_node_group_role_policy,
    aws_iam_role_policy_attachment.vedant_node_group_cni_policy,
    aws_iam_role_policy_attachment.vedant_node_group_registry_policy
  ]
}
