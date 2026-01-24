resource "aws_iam_role" "secrets_carrental" {
  name = "${var.eks_name}-secrets-carrental"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_policy" "secrets_carrental" {
  name = "${var.eks_name}-secrets-carrental"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource =  var.secrets_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_carrental" {
  policy_arn = aws_iam_policy.secrets_carrental.arn
  role       = aws_iam_role.secrets_carrental.name
}

resource "aws_eks_pod_identity_association" "secrets_carrental" {
  cluster_name    = var.eks_name
  namespace       = "default"
  service_account = "carrental-sa"
  role_arn        = aws_iam_role.secrets_carrental.arn
}

resource "helm_release" "secrets_csi_driver" {
    name = "secrets-store-csi-driver"

    repository      = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
    chart           = "secrets-store-csi-driver"
    namespace       = "kube-system"
    version         = "1.5.4"

    # Set for ENV variables
    set = [{
      name  = "syncSecret.enabled"
      value = true
    }]
}

#cloud secrets provider

resource "helm_release" "secrets_csi_driver_aws_provider" {
    name = "secrets-store-cri-driver-provider-aws"

    repository  = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
    chart       = "secrets-store-csi-driver-provider-aws"
    namespace   = "kube-system"
    version     = "0.3.11"

    depends_on = [helm_release.secrets_csi_driver]
}

