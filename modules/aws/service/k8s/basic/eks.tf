/** 
# EKS
*/
resource "aws_eks_cluster" "this" {
  name     = "${var.common.project}-${var.common.environment}-${var.common.service_name}-eks-cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.aws_eks_cluster_version

  vpc_config {
    subnet_ids = var.eks_subnet_ids
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.common.project}-${var.common.environment}-${var.common.service_name}-node-group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.eks_node_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }
}