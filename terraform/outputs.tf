output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubectl_config_command" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks.name}"
}