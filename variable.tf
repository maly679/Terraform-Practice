variable "eks-actions" {
  type    = string
  default = "sts:AssumeRole"
}

variable "service" {
  type    = string
  default = "Service"
}

variable "eks-identifier" {
  type    = string
  default = "eks.amazonaws.com"
}

variable "arn_resource_controller" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

variable "arn_cluster_policy" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

variable "cluster-name" {
  type    = string
  default = "eks-cluster"
}
