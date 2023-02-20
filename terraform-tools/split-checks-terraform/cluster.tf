resource "aws_eks_cluster" "eksKubernetesTest" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eksKubernetesTest.arn
  version = var.cluster_version
  

kubernetes_network_config{
  service_ipv4_cidr = var.kube_network_cfg
}

   vpc_config {
    subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id,aws_subnet.private_subnet[2].id]
    security_group_ids = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access = false

  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSVPCResourceController,
  ]
}
