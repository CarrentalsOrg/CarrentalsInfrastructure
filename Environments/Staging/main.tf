terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "3.0.2"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "C:/Users/Tiago/.kube/config"
  }
}

provider "aws" {
  region = "eu-west-3"
}

module "networking"{
  source = "./../../Modules/networking"

    environment      = var.environment
    region           = var.vpc_region
    zone1            = var.zone1
    zone2            = var.zone2

}



module "eks_cluster" {
    source = "./../../Modules/EKS_cluster"

  # Input Variables
    environment               = var.environment
    eks_name                  = var.eks_name
    eks_version               = var.eks_version
    eks_instances_type        = var.eks_instances_type
    vpc_id                    = module.networking.vpc_id
    subnet_private_zone1_id   = module.networking.subnet_private_zone1_id
    subnet_private_zone2_id   = module.networking.subnet_private_zone2_id

    depends_on = [ module.networking ]
}

module "K8s_eks_addons" {
  source = "./../../Modules/K8s_eks_addons"
  
  eks_name                            = module.eks_cluster.aws_eks_cluster_name
  eks_region                          = var.vpc_region
  vpc_id                              = module.networking.vpc_id
  enable_cluster_autoscaler           = true
  enable_aws_lbc                      = true
  enable_internal_nginx               = true
  enable_aws_secret_store             = true
  secrets_arn                         = var.secrets_arn
  
  depends_on = [ module.eks_cluster ]
}


module "rds_db" {
   source = "./../../Modules/RDS"
  
   db_name                    = var.database_name
   engine                     = var.database_engine
   vpc_id                     = module.networking.vpc_id
   subnet_private_zone1_id    = module.networking.subnet_private_zone1_id
   subnet_private_zone2_id    = module.networking.subnet_private_zone2_id
   allocated_storage          = var.database_allocated_storage

   depends_on = [ module.networking ]
}


# module "api_gateway" {
#   source = "./../../Modules/APIgateway"

#   vpc_id                      = module.networking.vpc_id
#   subnet_private_zone1_id     = module.networking.subnet_private_zone1_id
#   subnet_private_zone2_id     = module.networking.subnet_private_zone2_id
#   integration_uri             = var.api_gateway_integration_uri

# }

# output "signup_url" {
#   value = module.api_gateway.signup_url
# }
