resource "aws_eks_node_group" "Nodes" {
  cluster_name    = aws_eks_cluster.eksKubernetesTest.name
  node_group_name = var.eks_node_name
  node_role_arn   = aws_iam_role.eksKubernetesTest.arn
  subnet_ids      = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id,aws_subnet.private_subnet[2].id]
  disk_size       = var.node_disk
  instance_types  = var.node_instance_type
  remote_access {
  ec2_ssh_key = var.ssh_key_name
  }
  scaling_config {
    desired_size = 5
    max_size     = 6
    min_size     = 5
  }
  depends_on = [
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEC2ContainerRegistryReadOnly,
  ]
}

