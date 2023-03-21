output "cluster_id" {
    value =  aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
    value =  aws_eks_cluster.eks_cluster.arn
}

output "cluster_endpoint" {
    value =  aws_eks_cluster.eks_cluster.endpoint
}