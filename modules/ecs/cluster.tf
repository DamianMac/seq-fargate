resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster-${var.env_prefix}"

  tags = {
    Name = var.tag
  }
}


