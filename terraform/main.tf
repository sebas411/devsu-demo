resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "eks_subnets" {
  count             = 2
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = element(["us-west-2a", "us-west-2b"], count.index)
}

data "aws_iam_policy_document" "eks-cluster-admin-role-policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks-cluster-admin-role-policy.json
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}
