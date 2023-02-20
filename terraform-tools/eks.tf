##################
provider "aws"{
    region = "us-east-1"
}

resource "aws_eks_cluster" "eksKubernetesTest" {
  name     = "aws-eks-kubernetes"
  role_arn = aws_iam_role.eksKubernetesTest.arn
  version = "1.23"
  

kubernetes_network_config{
  service_ipv4_cidr = "10.101.0.0/16"
}

   vpc_config {
    subnet_ids = ["subnet-123454545", "subnet-yfdhgjsgjfgj"]
    security_group_ids = ["sg-00etrtetewttwer"]
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

output "endpoint" {
  value = aws_eks_cluster.eksKubernetesTest.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eksKubernetesTest.certificate_authority[0].data
}


###############

resource "aws_iam_role" "eksKubernetesTest" {
  name = "eks-cluster-test"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksKubernetesTest.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-ElasticLoadBalancingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksKubernetesTest.name
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksKubernetesTest.name
}
#################
resource "aws_eks_addon" "eksKubernetesTest" {
  cluster_name = aws_eks_cluster.eksKubernetesTest.name
  addon_name   = "vpc-cni"
}

data "tls_certificate" "eksKubernetesTest" {
  url = aws_eks_cluster.eksKubernetesTest.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eksKubernetesTest" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eksKubernetesTest.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eksKubernetesTest.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eksKubernetesTest_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eksKubernetesTest.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eksKubernetesTest.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eksKubernetesTest2" {
  assume_role_policy = data.aws_iam_policy_document.eksKubernetesTest_assume_role_policy.json
  name               = "eksKubernetesTest-vpc-cni-role"
}

resource "aws_iam_role_policy_attachment" "eksKubernetesTest" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksKubernetesTest.name
}

################### NODE_GROUPS

resource "aws_eks_node_group" "gp1" {
  cluster_name    = aws_eks_cluster.eksKubernetesTest.name
  node_group_name = "aws-eks-kubernetes-produccion-01-NodeGroup"
  node_role_arn   = "arn:aws:iam::787685826076:role/rc-aws-eks-kubernetes-produccion-01"
  subnet_ids      = ["subnet-vgfzcbzxcbzxc", "subnet-xzcbzxcbxzcbzxcb"]
  disk_size       = "20"
  instance_types  = ["t3.medium"]
  labels = {
    name = "eks-node"
    nodeType = "General"
   }
  remote_access {
  ec2_ssh_key = "private-environment"
  }
  scaling_config {
    desired_size = 7
    max_size     = 10
    min_size     = 7
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksKubernetesTest-AmazonEC2ContainerRegistryReadOnly,
  ]
}
