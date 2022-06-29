locals {
  env_name    = "Sample Seq Infra"
  env_prefix  = "seq-fargate"

}

module "network" {
  source = "../../modules/network"
  tag    = local.env_name
  region = "ap-southeast-2"
  az1    = "ap-southeast-2a"
  az2    = "ap-southeast-2c"

}

module "ecscluster" {
  source     = "../../modules/ecs"
  env_prefix = local.env_prefix
  tag        = local.env_name
  vpc_id     = module.network.vpc_id
  subnets    = module.network.subnets
  cert_arn   = aws_acm_certificate.infra-wildcard.arn
}

module "seq" {
  source             = "../../modules/services/seq"
  env_prefix         = local.env_prefix
  tag                = local.env_name
  service_version    = "2022.1"
  execution_role_arn = module.ecscluster.execution_role_arn
  cluster_id         = module.ecscluster.cluster_id
  vpc_id             = module.network.vpc_id
  vpc_cidr           = module.network.cidr_block
  subnets            = module.network.subnets
  zone_id            = aws_route53_zone.infra.id
  alb_zone_id        = module.ecscluster.alb_zone_id
  alb_dns_name       = module.ecscluster.alb_dns_name
  https_listener_arn = module.ecscluster.alb_https_listener_arn
}