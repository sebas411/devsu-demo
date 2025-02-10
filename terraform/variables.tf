variable "region" {
  description = "Region for the cluster"
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "eks-cluster"
}
