data "aws_iam_policy_document" "eks_role_assume_role_policy" {
  statement {
    actions = [var.eks-actions]
    principals {
    type = var.service
    identifiers = [var.eks-identifier]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = var.arn_cluster_policy
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = var.arn_resource_controller
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role" "eks-cluster" {
  name = var.cluster-name
  assume_role_policy = data.aws_iam_policy_document.eks_role_assume_role_policy.json

}

