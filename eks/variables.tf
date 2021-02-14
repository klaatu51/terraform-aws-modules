variable "cluster-name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources"
  default = "terraform-eks-demo"
  type = string
}

variable "cluster-version" {
  description = "Kubernetes version to use for the EKS cluster"
  default = "1.14"
  type = string
}

variable "instance-types" {
  description = "Node type to user for the worker nodes"
  type = string
  default = "t3.medium"
}