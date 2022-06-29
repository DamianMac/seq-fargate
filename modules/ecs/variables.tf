variable "tag" {
  description = "Description for resources"
}

variable "env_prefix" {
  description = "Prefix for identifier"
}

variable "subnets" {
  description = "Array of subnet IDs"
}

variable "vpc_id" {
  description = "VPC Id"
}

variable "cert_arn" {
  description = "ARN of ssl cert for load balancer"
}