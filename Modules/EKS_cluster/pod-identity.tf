resource "aws_eks_addon" "pod_identity"{
    cluster_name = aws_eks_cluster.eks.name
    addon_name = "eks-pod-identity-agent"
    addon_version = "v1.3.10-eksbuild.2"
    #disable ipv6 in EKS pod identity agent https://docs.aws.amazon.com/eks/latest/userguide/pod-id-agent-config-ipv6.html
    configuration_values = jsonencode({
    "agent": {
        "additionalArgs": {
            "-b": "169.254.170.23"
        }
    }
    })
}