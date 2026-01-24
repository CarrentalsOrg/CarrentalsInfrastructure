variable "secrets_arn" {
 description = "List of secret ARN resources"
 type        = list(string)
}

variable "eks_name" {
  description = "Name of the eks"
}

