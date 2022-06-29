variable "tag" {
  description = "Description for resources"
}

variable "env_prefix" {
  description = "Prefix for identifier"
}

variable "execution_role_arn" {
  description = "ARN of the service role"
}

variable "cluster_id" {
  description = "ID of ECS cluster"
}

variable "service_version" {
  description = "Version tag of the service"
}

variable "subnets" {
  description = "Array of subnet IDs"
}


variable "vpc_id" {
  description = "VPC Id"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "zone_id" {
  description = "DNS ZOne ID for creating subdomains"

}

variable "alb_zone_id" {
  description = "Zone ID of the load balancer"
}

variable "alb_dns_name" {
  description = "DNS name of the load balancer"
}

variable "https_listener_arn" {
  description = "ARN of HTTPS Listener on load balancer"
}