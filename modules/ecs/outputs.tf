output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_service_role.arn
}

output "alb_zone_id" {
  value = aws_alb.ecs-services-lb.zone_id
}

output "alb_dns_name" {
  value = aws_alb.ecs-services-lb.dns_name
}

output "alb_http_listener_arn" {

  value = aws_lb_listener.http_traffic.arn
}

output "alb_https_listener_arn" {

  value = aws_lb_listener.https_traffic.arn
}