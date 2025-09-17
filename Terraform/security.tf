resource "aws_security_group" "vedant_cluster_sg" {
  name   = "vedant-cluster-sg"
  vpc_id = aws_vpc.vedant_vpc.id

  description = "Cluster control-plane SG - egress open"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vedant-cluster-sg"
  }
}

resource "aws_security_group" "vedant_node_sg" {
  name   = "vedant-node-sg"
  vpc_id = aws_vpc.vedant_vpc.id

  description = "Node group SG - all traffic (adjust for production)"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vedant-node-sg"
  }
}
