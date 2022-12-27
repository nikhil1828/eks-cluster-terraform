resource "aws_eks_cluster" "eks-cluster" {
  name     = "eks-cluster"
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = [for v in var.pub-snet: v.snet-id]
    security_group_ids = [var.cluster-sg]
   }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  # depends_on = [
  #   aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
  #   aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  # ]

}

resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "my-cluster"
  node_role_arn   = var.woker_role_arn
  subnet_ids      = [for v in var.pub-snet: v.snet-id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  # depends_on = [
  #   aws_iam_role_policy_attachment.eks-cluster-AmazonEKSWorkerNodePolicy,
  #   aws_iam_role_policy_attachment.eks-cluster-AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.eks-cluster-AmazonEC2ContainerRegistryReadOnly,
  #   aws_iam_role_policy_attachment.eks-cluster-EC2InstanceProfileForImageBuilderECRContainerBuilds,
  # ]
}