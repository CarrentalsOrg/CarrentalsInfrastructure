
module "cluster-autoscaler" {
    source      =  "./cluster_autoscaler"
    count       =  var.enable_cluster_autoscaler? 1:0

    eks_name    = var.eks_name
    eks_region  = var.eks_region
}

module "aws-lbc" {
    source      =  "./aws_lbc"
    count       =  var.enable_aws_lbc? 1:0

    eks_name    = var.eks_name
    vpc_id      = var.vpc_id
}

module "external-nginx-ingress" {
    source  = "./external_nginx_ingress"
    count   = var.enable_external_nginx? 1:0

     depends_on = [ module.aws-lbc ] 
}

module "secrets-store-csi-driver" {
    source                              =  "./secrets_store_csi_driver"
    count                               =  var.enable_aws_secret_store? 1:0

    eks_name                            = var.eks_name
    secrets_arn                         = var.secrets_arn
}

module "cert_manager" {
    source                              =  "./cert_manager"
    count                               =  var.enable_cert_manager? 1:0
}