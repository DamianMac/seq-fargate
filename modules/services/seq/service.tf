resource "aws_ecs_task_definition" "seq" {
  family                   = "seq"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name      = "seq"
      image     = "datalust/seq:${var.service_version}"
      memory    = 4090
      essential = true
      environment = [
          {"name": "ACCEPT_EULA", "value": "Y"},
          {"name": "SEQ_CACHE_SYSTEMRAMTARGET", "value": "0.8"}
      ]
      portMappings = [
        {
          containerPort = 80
        }
      ],
      mountPoints = [
        {
          sourceVolume = "data",
          containerPath = "/data"
        }
      ]
    }
  ])


  volume {
    name = "data"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.seq-data.id
      
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = aws_efs_access_point.data.id
      }
    }
  }

}

resource "aws_ecs_service" "seq" {
  name                               = "seq"
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.seq.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  platform_version                   = "1.4.0"
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.private-ports.id]
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.seq.id
    container_name   = "seq"
    container_port   = "80"
  }

}


resource "aws_efs_file_system" "seq-data" {
  creation_token = "seq-${var.env_prefix}"

  tags = {
    Name = var.tag
  }
}

resource "aws_efs_access_point" "data" {
  file_system_id = aws_efs_file_system.seq-data.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
  }
tags = {
    Name = var.tag
  }
}

# Create the mount targets on your private subnets
resource "aws_efs_mount_target" "data" {
  count           = length(var.subnets)
  file_system_id  = aws_efs_file_system.seq-data.id
  subnet_id       = tolist(var.subnets)[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "efs-access"
  description = "Storage Access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}