##Cluster requires two subnets in different AZs for it to work
##Requires IAM policies
##Required Cloudwatch logs

resource "aws_eks_cluster" "eks-cluster" {
  name     = "example"
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}
