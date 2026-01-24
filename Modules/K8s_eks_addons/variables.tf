variable "eks_name" {
  description = "Name of the eks"
}

variable "eks_region" {
  description = "Region of the eks"

}

variable "vpc_id" {
  description = "Id of the selected vpc"

}

variable "enable_cluster_autoscaler" {
    description = "Enable or not cluster autoscaler"
    type = bool
    default = false
}

variable "enable_aws_lbc" {
    description = "Enable aws lbc"
    type = bool
    default = false
}

variable "enable_aws_secret_store" {
    description = "Enable aws secret store"
    type = bool
    default = false
}

variable "enable_internal_nginx" {
  type = bool
  default = false
  validation {
    condition     =  !var.enable_internal_nginx || var.enable_aws_lbc
    error_message = "aws load balancer controler must also be enabled"
  }
}

variable "secrets_arn" {
 description = "List of ARN resources"
 type        = list(string)
}
